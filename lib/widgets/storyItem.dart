import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hn/screens/story.dart';
import 'package:hn/widgets/baseText.dart';

class StoryItem extends StatefulWidget {
  final String storyId;

  const StoryItem({super.key, required this.storyId});

  @override
  State<StatefulWidget> createState() => StoryItemState();
}

class StoryItemState extends State<StoryItem> {
  @override
  Widget build(BuildContext context) {
    return Material(
        child: CupertinoListTile(
      onTap: () {
        Navigator.push(
            context, CupertinoPageRoute(builder: (context) => StoryScreen()));
      },
      backgroundColor: Colors.black,
      title: Text(
        "Bard: an AI by Google",
        softWrap: true,
        overflow: TextOverflow.ellipsis,
        maxLines: 3,
        style: baseTextStyle.copyWith(
            fontSize: 22.0, fontWeight: FontWeight.bold, height: 1.4),
      ),
      subtitle: Text(
        "google.com\n4 comments | 4 points | posted by someone",
        maxLines: 3,
        style: TextStyle(fontSize: 14.0),
      ),
    ));
  }
}
