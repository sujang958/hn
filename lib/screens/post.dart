// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hn/models/commentModel.dart';
import 'package:hn/models/item.dart';
import 'package:hn/widgets/baseText.dart';
import 'package:hn/widgets/commentItem.dart';
import 'package:url_launcher/url_launcher.dart';

class PostItemScreen extends StatefulWidget {
  final PostItem postItem;

  const PostItemScreen({super.key, required this.postItem});

  @override
  State<StatefulWidget> createState() => PostItemScreenState();
}

class PostItemScreenState extends State<PostItemScreen> {
  late PostItem postItem;

  final scrollController = ScrollController();

  int? currentFocusedReply;
  Map<int, List<Comment>> replies = {};

  double previousScrollOffset = 0.0;

  @override
  void initState() {
    super.initState();

    postItem = widget.postItem;
  }

  Future<bool> _recursionReply(
      Comment topComment, Comment comment, List<int> replyIds) async {
    setState(() {
      replies[topComment.id] = [];
    });

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
    final commentIds = postItem.commentIds;

    if (commentIds == null) {
      throw Exception("No Comments");
    }

    for (final commentId in commentIds) {
      final comment = await fetchComment(id: commentId);
      if (comment == null) continue;
      comments.add(comment);
    }

    await Future.wait([
      for (final comment in comments)
        _recursionReply(comment, comment, comment.replyIds)
    ]);
  }

  void _refreshStory() async {
    try {
      final fetchedStory = await fetchPostItem(id: postItem.id);

      if (fetchedStory == null) {
        throw Exception("Cannot find the story");
      }

      setState(() {
        currentFocusedReply = null;
        replies = {};
        postItem = fetchedStory;
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
                            if (postItem.url == null) {
                              return;
                            }
                            if (!await launchUrl(
                                Uri.parse(postItem.url as String))) {
                              return;
                            }
                          },
                          child: Text(
                            postItem.title,
                            style: baseTextStyle.copyWith(
                                fontWeight: FontWeight.bold),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          )),
                      padding: EdgeInsetsDirectional.symmetric(
                          horizontal: 18.0, vertical: 0.0),
                      largeTitle: SizedBox.shrink(),
                      transitionBetweenRoutes: true,
                      backgroundColor: Colors.black,
                    ),
                    CupertinoSliverRefreshControl(onRefresh: () async {
                      _refreshStory();
                    }),
                    SliverToBoxAdapter(
                      child: CupertinoButton(
                        onPressed: () async {
                          if (postItem.url == null) {
                            return;
                          }
                          if (!await launchUrl(
                              Uri.parse(postItem.url as String))) {
                            return;
                          }
                        },
                        padding: EdgeInsets.only(
                            left: 18.0, right: 18.0, bottom: 48.0),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          postItem.title,
                          style: baseTextStyle.copyWith(
                              fontWeight: FontWeight.bold, fontSize: 33.0),
                          maxLines: 8,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    if (postItem.content != null &&
                        (postItem.content ?? "").trim().isNotEmpty)
                      SliverToBoxAdapter(
                        child: StatelessCommentItem(
                          comment: Comment(
                              id: -1,
                              by: postItem.by,
                              time: postItem.time,
                              replyIds: [],
                              text: postItem.content as String),
                          onReplyButtonTap: () {},
                          replyButtonShown: false,
                        ),
                      ),
                    if (currentFocusedReply == null &&
                        postItem.commentIds != null)
                      SliverList(
                          delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                        final commentId = postItem.commentIds?[index];

                        if (commentId == null) {
                          setState(() {
                            postItem.commentIds?.removeAt(index);
                          });
                          return SizedBox.shrink();
                        }

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
                      }, childCount: postItem.commentIds?.length as int))
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
