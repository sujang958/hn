import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hn/widgets/baseText.dart';
import 'package:hn/widgets/postItemWidget.dart';

class ReadingListWidget extends StatefulWidget {
  const ReadingListWidget({super.key});

  @override
  State<StatefulWidget> createState() => ReadlingListWidgetState();
}

class ReadlingListWidgetState extends State<ReadingListWidget> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
            brightness: Brightness.dark,
            backgroundColor: Colors.black,
            middle: Text("Reading List", style: baseTextStyle.copyWith(fontWeight: FontWeight.w700, fontSize: 18.4),)),
        child: ListView(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            children: [
            PostItemWidget(postItemId: 36006423),
          ]),
        );
  }
}
