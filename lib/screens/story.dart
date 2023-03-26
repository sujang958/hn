// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hn/widgets/baseText.dart';

class StoryScreen extends StatefulWidget {
  const StoryScreen({super.key});

  @override
  State<StatefulWidget> createState() => StoryScreenState();
}

class StoryScreenState extends State<StoryScreen> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        child: Column(
      children: [
        Expanded(
            child: CustomScrollView(
          physics: BouncingScrollPhysics(),
          slivers: [
            CupertinoSliverNavigationBar(
              previousPageTitle: "Top Stories",
              largeTitle: CupertinoButton(
                child: Text(
                  "Bard: an AI by Google",
                  style: baseTextStyle.copyWith(
                      fontWeight: FontWeight.bold, fontSize: 32.0),
                  maxLines: 3,
                ),
                onPressed: () {},
                padding: EdgeInsets.zero,
                alignment: Alignment.centerLeft,
              ),
              transitionBetweenRoutes: true,
              backgroundColor: Colors.black,
            ),
            CupertinoSliverRefreshControl(),
            SliverList(
                delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) => Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 18.0),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Google 3 hours ago",
                                  style: baseTextStyle.copyWith(
                                      color: CupertinoColors.systemGrey2,
                                      fontSize: 14.0),
                                ),
                                Text(
                                  "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi convallis nunc at dignissim aliquet. Suspendisse gravida eros id mi vestibulum scelerisque. Suspendisse potenti. Ut euismod lobortis leo ac sagittis. Praesent porttitor fringilla nulla, ut vestibulum felis. Cras aliquet justo velit, ac ornare nibh placerat a. Aliquam sed gravida mi. ",
                                  style: baseTextStyle.copyWith(
                                      fontSize: 18.4, height: 1.3),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 4.0),
                                ),
                                CupertinoButton(
                                  child: Text("View replies", style: TextStyle(fontSize: 16.0),),
                                  onPressed: () {},
                                  padding: EdgeInsets.zero,
                                )
                              ]),
                        ),
                    childCount: 2))
          ],
        ))
      ],
    ));
  }
}
