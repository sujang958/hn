import 'package:shared_preferences/shared_preferences.dart';

const readingListKey = "READING_LIST";

Future<List<String>> getReadingList() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final list = prefs.getStringList(readingListKey);
  if (list == null) {
    prefs.setStringList(readingListKey, []);

    return [];
  }

  return list;
}

Future<List<String>> setReadingList(List<String> list) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  await prefs.setStringList(readingListKey, list.toSet().toList());

  return list;
}

Future<bool> isAddedToReadlingList(String id) async {
  final list = await getReadingList();
  return list.contains(id);
}

Future<void> addToReadingList(String id) async {
  final list = await getReadingList();

  if (list.contains(id)) return;

  list.add(id);

  await setReadingList(list);
}

Future<void> removeFromReadingList(String id) async {
  final list = await getReadingList();

  if (!list.contains(id)) return;

  list.remove(id);

  await setReadingList(list);
}
