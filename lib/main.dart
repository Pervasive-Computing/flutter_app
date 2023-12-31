import 'package:flutter/material.dart';
import 'package:catppuccin_flutter/catppuccin_flutter.dart';
import 'home.dart';
import 'themes/catppuccin_theme.dart';
import 'websocket/simulation_api.dart';

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
  final _themeNotifier = ValueNotifier<Flavor>(catppuccin.mocha);
  final GlobalKey<HomeState> _homeKey = GlobalKey<HomeState>();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _themeNotifier,
      builder: (_, catppuccinFlavor, __) {
        return MaterialApp(
          title: 'UrbanOS',
          theme: catppuccinTheme(
            catppuccinFlavor,
            context: context,
          ),
          home: Home(
            key: _homeKey,
            themeNotifier: _themeNotifier,
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _themeNotifier.dispose();
  }
}
