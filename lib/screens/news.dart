// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hn/models/constants.dart';
import 'package:hn/models/list.dart';
import 'package:hn/widgets/baseText.dart';
import 'package:hn/widgets/postItemWidget.dart';

Future<List<int>> conditionalFetchStories(String type) async {
  switch (type) {
    case "story":
      return fetchList(url: topStoriesUri);
    case "job":
      return fetchList(url: jobStoriesUri);
    case "ask":
      return fetchList(url: askStoriesUri);
    case "show":
      return fetchList(url: showStoriesUri);
    default:
      return fetchList(url: topStoriesUri);
  }
}

class NewsScreen extends StatefulWidget {
  final String type; // can be story, job, ask, show
  final String title;

  const NewsScreen({super.key, required this.type, required this.title});

  @override
  State<StatefulWidget> createState() => NewsScreenState();
}

class NewsScreenState extends State<NewsScreen> {
  late Future<List<int>> ids;

  @override
  void initState() {
    super.initState();

    ids = conditionalFetchStories(widget.type);
  }

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
                  widget.title,
                  style: baseTextStyle.copyWith(
                    fontVariations: [FontVariation('wght', 700)],
                  ),
                ),
              ),
              CupertinoSliverRefreshControl(
                onRefresh: () async {
                  setState(() {
                    ids = conditionalFetchStories(widget.type);
                  });
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
                      (BuildContext context, int index) => PostItemWidget(
                        postItemId: data[index],
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
