import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  final _themeNotifier = ValueNotifier('mocha');
  final GlobalKey<HomeState> _homeKey = GlobalKey<HomeState>();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _themeNotifier,
      builder: (_, themeName, __) {
        return MaterialApp(
          title: 'UrbanOS',
          theme: catppuccinTheme(
            flavorMap[themeName]!,
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
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
  }
}
