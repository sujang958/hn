// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hn/screens/story.dart';
import 'package:hn/widgets/baseText.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<StatefulWidget> createState() => NewsScreenState();
}

class NewsScreenState extends State<NewsScreen> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: Colors.black,
      child: Column(
        children: [
          Expanded(
              child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: <Widget>[
              CupertinoSliverNavigationBar(
                transitionBetweenRoutes: true,
                backgroundColor: Colors.black,
                largeTitle: Text(
                  "Top Stories",
                  style: baseTextStyle.copyWith(
                    fontVariations: [FontVariation('wght', 700)],
                  ),
                ),
              ),
              CupertinoSliverRefreshControl(
                onRefresh: () async {},
              ),
              SliverPadding(padding: EdgeInsets.symmetric(vertical: 6.0)),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) => Material(
                      child: CupertinoListTile(
                    onTap: () {
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => StoryScreen()));
                    },
                    backgroundColor: Colors.black,
                    title: Text(
                      "Bard: an AI by Google",
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                      style: baseTextStyle.copyWith(
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold,
                          height: 1.4),
                    ),
                    subtitle: Text(
                      "google.com\n4 comments | 4 points | posted by someone",
                      maxLines: 3,
                      style: TextStyle(fontSize: 14.0),
                    ),
                  )),
                  childCount: 16,
                ),
              ),
            ],
          )),
        ],
      ),
    );
  }
}
