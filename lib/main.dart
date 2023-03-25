import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hn/screens/news.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Hacker News',
        themeMode: ThemeMode.dark,
        theme: ThemeData(
          fontFamily: "Pretendard",
          brightness: Brightness.dark,
          scaffoldBackgroundColor: CupertinoColors.black,
        ),
        home: const MainWidget());
  }
}

class MainWidget extends StatelessWidget {
  const MainWidget({super.key});

  @override
  Widget build(BuildContext context) {
    List<BottomNavigationBarItem> items = [
      const BottomNavigationBarItem(
        icon: Icon(CupertinoIcons.news, size: 24.0),
        label: 'News',
      ),
      const BottomNavigationBarItem(
        icon: Icon(CupertinoIcons.bubble_left, size: 24.0),
        label: 'Ask',
      ),
      const BottomNavigationBarItem(
        icon: Icon(
          CupertinoIcons.flame,
          size: 24.0,
        ),
        label: 'Show',
      ),
      const BottomNavigationBarItem(
        icon: Icon(CupertinoIcons.briefcase, size: 24.0),
        label: 'Jobs',
      ),
    ];

    return DefaultTextStyle(
        style: const TextStyle(
            fontFamily: "Pretendard",
            color: Colors.white,
            decoration: TextDecoration.none,
            fontWeight: FontWeight.normal),
        child: CupertinoTabScaffold(
            tabBar: CupertinoTabBar(items: items),
            tabBuilder: (context, index) {
              switch (index) {
                case 0:
                  return const NewsScreen();
                case 1:
                  return const NewsScreen();
                case 2:
                  return const NewsScreen();
                default:
                  return const NewsScreen();
              }
            }));
  }
}
