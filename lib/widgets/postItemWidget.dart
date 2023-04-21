import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hn/models/item.dart';
import 'package:hn/screens/post.dart';
import 'package:hn/widgets/baseText.dart';

class PostItemWidget extends StatefulWidget {
  final int postItemId;

  const PostItemWidget({super.key, required this.postItemId});

  @override
  State<StatefulWidget> createState() => PostItemWidgetState();
}

class PostItemWidgetState extends State<PostItemWidget> {
  late Future<PostItem?> postItem;

  @override
  void initState() {
    super.initState();

    postItem = fetchPostItem(id: widget.postItemId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: ((context, snapshot) {
        print(snapshot.hasError);
        print(snapshot.data);
        if (snapshot.hasError) {
          print(snapshot.error);
        }

        if (snapshot.hasError || !snapshot.hasData) {
          return const SizedBox.shrink();
        }

        final story = snapshot.data as PostItem;

        return Material(
            child: CupertinoListTile(
          padding: const EdgeInsets.symmetric(vertical: 7.0, horizontal: 18.0),
          onTap: () {
            Navigator.push(
                context,
                CupertinoPageRoute(
                    builder: (context) => PostItemScreen(postItem: story)));
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
            "${story.url != null ? "${Uri.parse(story.url as String).host}\n" : ""}${story.commentIds != null ? "${story.commentIds?.length as int} comments" : ""} | ${story.score} points | posted by ${story.by}",
            maxLines: 3,
            style: const TextStyle(fontSize: 14.5),
          ),
        ));
      }),
      future: postItem,
    );
  }
}
