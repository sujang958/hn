import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hn/models/storyModel.dart';
import 'package:hn/screens/story.dart';
import 'package:hn/widgets/baseText.dart';

class StoryItem extends StatefulWidget {
  final int storyId;

  const StoryItem({super.key, required this.storyId});

  @override
  State<StatefulWidget> createState() => StoryItemState();
}

class StoryItemState extends State<StoryItem> {
  late Future<Story?> story;

  @override
  void initState() {
    super.initState();

    story = fetchStory(id: widget.storyId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(builder: ((context, snapshot) {
      if (snapshot.hasError || !snapshot.hasData) {
        return const SizedBox.shrink();
      }

      final story = snapshot.data as Story;

      return Material(
          child: CupertinoListTile(
            padding: const EdgeInsets.symmetric(vertical: 7.0, horizontal: 18.0),
        onTap: () {
          Navigator.push(
              context, CupertinoPageRoute(builder: (context) => StoryScreen()));
        },
        backgroundColor: Colors.black,
        title: Text(
          story.title,
          softWrap: true,
          overflow: TextOverflow.ellipsis,
          maxLines: 3,
          style: baseTextStyle.copyWith(
              fontSize: 22.0, fontWeight: FontWeight.bold, height: 1.4),
        ),
        subtitle: Text(
          "${Uri.parse(story.url).host}\n${story.commentIds.length} comments | ${story.score} points | posted by ${story.by}",
          maxLines: 3,
          style: TextStyle(fontSize: 14.5),
        ),
      ));
    }), future: story,);
  }
}
