import 'package:catppuccin_flutter/catppuccin_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'home.dart';
import 'themes/themes.dart';
import '../websocket/simulation_api.dart';

void main() {
  SimulationAPI.connect();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  final _themeNotifier = ValueNotifier('latte');

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _themeNotifier,
      builder: (_, themeName, __) {
        return MaterialApp(
          title: 'What the heck do we call this app?',
          theme: catppuccinTheme(flavorMap[themeName]!),
          home: Home(
            themeNotifier: _themeNotifier,
          ),
        );
      },
    );
    // return MaterialApp(
    //   title: 'What the heck do we call this app?',
    //   theme: catppuccinTheme(catppuccin.latte),
    //   home: const Home(),
    // );
  }
}
