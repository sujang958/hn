import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:hn/models/commentModel.dart';
import 'package:hn/widgets/baseText.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:url_launcher/url_launcher.dart';

class CommentItem extends StatefulWidget {
  final int commentId;

  const CommentItem({super.key, required this.commentId});

  @override
  State<StatefulWidget> createState() => CommendItemState();
}

class CommendItemState extends State<CommentItem> {
  late Future<Comment?> comment;

  String getPassedTime(int when) {
    final passedTime = DateTime.now().subtract(Duration(milliseconds: when));

    return timeago.format(passedTime);
  }

  @override
  void initState() {
    super.initState();

    comment = fetchComment(id: widget.commentId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: comment,
        builder: (context, snapshot) {
          if (snapshot.hasError || !snapshot.hasData) {
            return const SizedBox.shrink();
          }

          final comment = snapshot.data as Comment;

          return Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 12.0, horizontal: 18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${comment.by} ${getPassedTime(comment.time)}",
                    style: baseTextStyle.copyWith(
                        color: CupertinoColors.systemGrey2, fontSize: 14.0),
                  ),
                  DefaultTextStyle(
                      style: baseTextStyle,
                      child: Html(
                        data: comment.text,
                        style: {
                          "*": Style(
                              padding: EdgeInsets.zero,
                              margin: EdgeInsets.zero,
                              fontSize: FontSize.rem(1.18),
                              lineHeight: LineHeight.number(1.15)),
                          "pre": Style(
                              backgroundColor:
                                  CupertinoColors.darkBackgroundGray,
                              width: double.infinity,
                              margin:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 4.0, horizontal: 0.2)),
                          "anchor": Style(textDecoration: TextDecoration.none),
                        },
                        onLinkTap: (url, context, attributes, element) {
                          if (url != null) {
                            launchUrl(Uri.parse(url));
                          }
                        },
                      )),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 4.0),
                  ),
                  CupertinoButton(
                    onPressed: () {},
                    padding: EdgeInsets.zero,
                    child: const Text(
                      "View replies",
                      style: TextStyle(fontSize: 15.0),
                    ),
                  ),
                ],
              ));
        });
  }
}
