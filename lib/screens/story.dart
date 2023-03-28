// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();

    story = widget.story;
  }

  @override
  Widget build(BuildContext context) {
    final tail = story.title.split(" ");
    final head = tail.removeAt(0);

    return CupertinoPageScaffold(
        child: Column(children: [
      Expanded(
          child: CustomScrollView(
              anchor: 0.0,
              physics: BouncingScrollPhysics(),
              slivers: [
            CupertinoSliverNavigationBar(
              alwaysShowMiddle: false,
              middle: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () async {
                    if (!await launchUrl(Uri.parse(story.url))) {
                      return;
                    }
                  },
                  child: Text(
                    story.title,
                    style: baseTextStyle.copyWith(fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  )),
              padding: EdgeInsetsDirectional.symmetric(
                  horizontal: 18.0, vertical: 0.0),
              // largeTitle: CupertinoButton(
              //   onPressed: () async {
              //     if (!await launchUrl(Uri.parse(story.url))) {
              //       return;
              //     }
              //   },
              //   padding: EdgeInsets.zero,
              //   alignment: Alignment.centerLeft,
              //   child: Text(
              //     head,
              //     style: baseTextStyle.copyWith(
              //         fontWeight: FontWeight.bold, fontSize: 32.0),
              //     maxLines: 1,
              //     softWrap: true,
              //     overflow: TextOverflow.ellipsis,
              //   ),
              // ),
              largeTitle: SizedBox.shrink(),
              trailing: Text(
                story.url.trim().isEmpty ? "No link provided" : "",
                style:
                    baseTextStyle.copyWith(color: CupertinoColors.systemGrey),
              ),
              transitionBetweenRoutes: true,
              backgroundColor: Colors.black,
            ),
            SliverToBoxAdapter(
              child: CupertinoButton(
                onPressed: () async {
                  if (!await launchUrl(Uri.parse(story.url))) {
                    return;
                  }
                },
                padding: EdgeInsets.only(left: 18.0, right: 18.0, bottom: 48.0),
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
            CupertinoSliverRefreshControl(onRefresh: () async {
              try {
                final fetchedStory = await fetchStory(id: story.id);

                if (fetchedStory == null) {
                  throw Exception("Cannot find the story");
                }

                story = fetchedStory;
              } catch (e) {
                // todo: add some dialog to show there was en error while fetching a story
              }
            }),
            SliverList(
                delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) =>
                        CommentItem(commentId: story.commentIds[index]),
                    childCount: story.commentIds.length)),
            SliverFillRemaining(),
          ]))
    ]));
  }
}
