import 'dart:async';
import 'dart:convert';

import 'package:hn/models/constants.dart';
import 'package:http/http.dart' as http;

class Comment {
  final String type = "comment";
  final List<int> replyIds;
  final int time;
  final String by;
  final int id;

  String text;

  Comment({
    required this.id,
    required this.by,
    required this.time,
    required this.replyIds,
    required this.text,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      text: json['text'] ?? '',
      id: json['id'],
      by: json['by'],
      replyIds: json['kids'] == null ? [] : List.from(json['kids']),
      time: json['time'],
    );
  }
}

Future<Comment?> fetchComment({required int id}) async {
  final storyResponse = await http.get(Uri.parse('$itemUri/$id.json'));

  if (storyResponse.statusCode >= 400) {
    throw Exception("Can't fetch stories!");
  }

  final json = jsonDecode(storyResponse.body);
  if (json == null) {
    return null;
  }
  if (json['deleted'] != null && json['deleted'] == true) {
    return null;
  }
  if (json["type"] != "comment") {
    return null;
  }
  if (json["text"].toString().trim().isEmpty) {
    return null;
  }
  
  return Comment.fromJson(json);
}
