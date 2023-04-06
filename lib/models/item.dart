import 'dart:convert';

import 'package:hn/models/constants.dart';
import 'package:http/http.dart' as http;

// ask, job, story(show hn)

class PostItem {
  final String type;
  final int id;
  final int score;
  final String title;

  final String by;
  final int time;

  String? content;
  String? url; // ask doesn't have this
  List<int>? commentIds; // job doesn't have this

  PostItem(
      {required this.id,
      required this.type,
      required this.score,
      required this.title,
      this.content,
      required this.by,
      required this.time,
      this.url,
      this.commentIds});

  factory PostItem.fromJson(dynamic json) {
    return PostItem(
        content: json['text'] ?? '',
        id: json['id'],
        by: json['by'],
        commentIds: json['kids'] == null ? [] : List.from(json['kids']),
        score: json['score'],
        time: json['time'],
        title: json['title'],
        url: json['url'] ?? '',
        type: json['type']);
  }
}

Future<PostItem?> fetchPostItem({required int id}) async {
  final storyResponse = await http.get(Uri.parse('$itemUri/$id.json'));

  if (storyResponse.statusCode >= 400) {
    throw Exception("Can't fetch stories!");
  }

  final json = jsonDecode(storyResponse.body);
  if (json['deleted'] != null && json['deleted'] == true) {
    return null;
  }
  if (json["type"] != "story") {
    return null;
  }

  return PostItem.fromJson(json);
}
