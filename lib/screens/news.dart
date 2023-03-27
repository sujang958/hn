// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hn/models/storyModel.dart';
import 'package:hn/widgets/baseText.dart';
import 'package:hn/widgets/storyItem.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<StatefulWidget> createState() => NewsScreenState();
}

class NewsScreenState extends State<NewsScreen> {
  Future<List<int>> ids = fetchTopStories(count: 20);

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
                onRefresh: () async {
                  ids = fetchTopStories();
                },
              ),
              SliverPadding(padding: EdgeInsets.symmetric(vertical: 6.0)),
              FutureBuilder(
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return SliverToBoxAdapter(
                      child: Text(
                        "There was an error :(",
                        style: baseTextStyle,
                      ),
                    );
                  }

                  if (!snapshot.hasData) {
                    return SliverList(
                        delegate: SliverChildBuilderDelegate(
                            (context, index) => null));
                  }

                  final data = snapshot.data as List<int>;

                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) => StoryItem(
                        storyId: data[index],
                      ),
                      childCount: data.length,
                    ),
                  );
                },
                future: ids,
              )
            ],
          )),
        ],
      ),
    );
  }
}
