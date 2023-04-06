import 'dart:convert';
import 'package:http/http.dart' as http;

Future<List<int>> fetchList({int? count, required String url}) async {
  final askStoryResponse = await http.get(Uri.parse(url));

  if (askStoryResponse.statusCode >= 400) {
    throw Exception("Can't fetch stories!");
  }

  final ids = (jsonDecode(askStoryResponse.body) as List<dynamic>)
      .whereType<int>()
      .toList();

  return count != null ? ids.take(count).toList() : ids;
}
