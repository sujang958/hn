// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hn/models/commentModel.dart';
import 'package:hn/models/storyModel.dart';
import 'package:hn/widgets/baseText.dart';
import 'package:hn/widgets/commentItem.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class StoryScreen extends StatefulWidget {
  final Story story;

  const StoryScreen({super.key, required this.story});

  @override
  State<StatefulWidget> createState() => StoryScreenState();
}

class StoryScreenState extends State<StoryScreen> {
  late Story story;

  final scrollController = ScrollController();

  int? currentFocusedReply = null;
  Map<int, List<Comment>> replies = {};

  double previousScrollOffset = 0.0;

  @override
  void initState() {
    super.initState();

    story = widget.story;
  }

  Future<bool> _recursionReply(
      Comment topComment, Comment comment, List<int> replyIds) async {
    for (final replyId in replyIds) {
      final reply = await fetchComment(id: replyId);
      if (reply == null) continue;
      if (replies[topComment.id] == null) {
        replies[topComment.id] = [];
      }
      if (topComment.by != comment.by) {
        reply.text = "@${comment.by} ${reply.text}";
      }

      setState(() {
        replies[topComment.id]?.add(reply);
      });

      if (reply.replyIds.isNotEmpty) {
        await _recursionReply(topComment, reply, reply.replyIds);
      }
      // todo: this to async
    }

    return true;
  }

  Future<bool> _getReplies(int commentId) async {
    final comment = await fetchComment(id: commentId);

    if (comment == null) {
      return false;
    }

    await _recursionReply(comment, comment, comment.replyIds);

    return true;
  }

  Future<void> _getAllReplies() async {
    final List<Comment> comments = [];
    for (final commentId in story.commentIds) {
      final comment = await fetchComment(id: commentId);
      if (comment == null) continue;
      comments.add(comment);
    }

    await Future.wait([
      for (final comment in comments)
        _recursionReply(comment, comment, comment.replyIds)
    ]);

    // for (final replyEntry in replies.entries) {
    //   final replyComments = replies[replyEntry.key];
    //   if (replyComments == null) continue;
    //   replyComments.sort((a, b) {
    //     return a.time.compareTo(b.time);
    //   });
    // }

    // comments.forEach((element) {
    //   print(
    //       "${element.text.split(" ")[0]} ${replies[element.id]?.map((e) => e.text.substring(0, min(20, e.text.length - 1))).join(";\n")} ${replies[element.id]?.length} ${replies[element.id]?.toSet().length}");
    //   print("______ \n\n\n");
    // });
  }

  void _refreshStory() async {
    try {
      final fetchedStory = await fetchStory(id: story.id);

      if (fetchedStory == null) {
        throw Exception("Cannot find the story");
      }

      setState(() {
        currentFocusedReply = null;
        replies = {};
        story = fetchedStory;
      });
    } catch (e) {
      // todo: add some dialog to show there was en error while fetching a story
    }
  }

  void animateScrollTo(double offset) {
    scrollController.animateTo(offset,
        duration: Duration(milliseconds: 200), curve: Curves.bounceInOut);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
        style: baseTextStyle,
        child: Scaffold(
            floatingActionButton: Visibility(
                visible: currentFocusedReply == null ? false : true,
                child: FloatingActionButton(
                    onPressed: () {
                      setState(() {
                        currentFocusedReply = null;
                        Future.delayed(Duration(milliseconds: 300)).then((_) {
                          animateScrollTo(previousScrollOffset);
                        });
                      });
                    },
                    backgroundColor: Colors.white,
                    child: Icon(
                      CupertinoIcons.back,
                      color: Colors.black,
                      size: 26.0,
                    ))),
            body: Column(children: [
              Expanded(
                  child: CustomScrollView(
                      anchor: 0.0,
                      controller: scrollController,
                      physics: BouncingScrollPhysics(),
                      slivers: [
                    CupertinoSliverNavigationBar(
                      alwaysShowMiddle: false,
                      middle: GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () async {
                            _getAllReplies();
                            if (!await launchUrl(Uri.parse(story.url))) {
                              return;
                            }
                          },
                          child: Text(
                            story.title,
                            style: baseTextStyle.copyWith(
                                fontWeight: FontWeight.bold),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          )),
                      padding: EdgeInsetsDirectional.symmetric(
                          horizontal: 18.0, vertical: 0.0),
                      largeTitle: SizedBox.shrink(),
                      trailing: Text(
                        story.url.trim().isEmpty ? "No link provided" : "",
                        style: baseTextStyle.copyWith(
                            color: CupertinoColors.systemGrey),
                      ),
                      transitionBetweenRoutes: true,
                      backgroundColor: Colors.black,
                    ),
                    CupertinoSliverRefreshControl(onRefresh: () async {
                      _refreshStory();
                    }),
                    SliverToBoxAdapter(
                      child: CupertinoButton(
                        onPressed: () async {
                          if (!await launchUrl(Uri.parse(story.url))) {
                            return;
                          }
                        },
                        padding: EdgeInsets.only(
                            left: 18.0, right: 18.0, bottom: 48.0),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          story.title,
                          style: baseTextStyle.copyWith(
                              fontWeight: FontWeight.bold, fontSize: 33.0),
                          maxLines: 8,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    if (currentFocusedReply == null)
                      SliverList(
                          delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                        final commentId = story.commentIds[index];

                        return CommentItem(
                            commentId: commentId,
                            onReplyButtonTap: () {
                              _getReplies(commentId);
                              previousScrollOffset =
                                  (scrollController.offset).toDouble();
                              animateScrollTo(0);
                              setState(() {
                                currentFocusedReply = commentId;
                              });
                            });
                      }, childCount: story.commentIds.length))
                    else if (replies.containsKey(currentFocusedReply))
                      SliverList(
                          delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int _index) {
                        final index = _index - 1;

                        if (index.isNegative) {
                          return Column(
                            children: [
                              CommentItem(
                                commentId: currentFocusedReply as int,
                                replyButtonShown: false,
                                onReplyButtonTap: () {},
                              ),
                              Divider(
                                color: CupertinoColors.systemGrey,
                              ),
                            ],
                          );
                        }

                        return StatelessCommentItem(
                          comment:
                              replies[currentFocusedReply]?[index] as Comment,
                          replyButtonShown: false,
                          onReplyButtonTap: () {},
                        );
                      },
                              childCount:
                                  replies[currentFocusedReply]?.length != null
                                      ? (replies[currentFocusedReply]?.length
                                              as int) +
                                          1
                                      : 1))
                    else
                      SliverFillRemaining(
                        child: CupertinoActivityIndicator(),
                      ),
                    SliverFillRemaining(),
                  ]))
            ])));
  }
}
