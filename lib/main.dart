import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'home.dart';
import 'themes/themes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  // ignore: prefer_final_fields
  static String _themeName = kDebugMode ? 'dark' : 'dark';
  final String _textThemeName = 'default';

  final ValueNotifier<String> _themeNotifier = ValueNotifier(_themeName);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
        valueListenable: _themeNotifier,
        builder: (_, themeValue, __) {
          return MaterialApp(
            title: 'What the heck do we call this app?',
            theme: buildThemeData(themeValue, _textThemeName),
            home: const Home(),
          );
        });
  }
}
