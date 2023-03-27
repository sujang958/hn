import 'dart:async';
import 'dart:convert';

import 'package:hn/models/constants.dart';
import 'package:http/http.dart' as http;

class Story {
  final String type = "story";
  final List<int> commentIds;
  final int score;
  final String title;
  final String url;
  final String content;
  final String by;
  final int id;

  const Story({
    required this.id,
    required this.by,
    required time,
    required this.commentIds,
    required this.score,
    required this.title,
    required this.url,
    required this.content,
  });

  factory Story.fromJson(Map<String, dynamic> json) {
    return Story(
      content: json['text'] ?? '',
      id: json['id'],
      by: json['by'],
      commentIds: json['kids'] == null ? [] : List.from(json['kids']),
      score: json['score'],
      time: json['time'],
      title: json['title'],
      url: json['url'] ?? '',
    );
  }
}

Future<List<int>> fetchTopStories({int? count}) async {
  final topStoryResponse = await http.get(Uri.parse(topStoriesUri));

  if (topStoryResponse.statusCode >= 400) {
    throw Exception("Can't fetch stories!");
  }

  final ids = (jsonDecode(topStoryResponse.body) as List<dynamic>)
      .whereType<int>().toList();

  return count != null ? ids.take(count).toList() : ids;
}

Future<Story?> fetchStory({required int id}) async {
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


  return Story.fromJson(json);
}
