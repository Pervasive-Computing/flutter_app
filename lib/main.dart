import 'package:flutter/material.dart';
import 'home.dart';
import 'themes/themes.dart';
// import '../websocket/simulation_api.dart';
import 'logger.dart';
import 'package:dartzmq/dartzmq.dart';

void main() {
  // SimulationAPI.connect();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  final _themeNotifier = ValueNotifier('mocha');

  final ZContext _context = ZContext();
  late final ZSocket _socket = _context.createSocket(SocketType.sub);

  // construvtor
  MyAppState() {
    _socket.connect('tcp://localhost:9001');

    _socket.payloads.listen((message) {
      l.i(message);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _themeNotifier,
      builder: (_, themeName, __) {
        return MaterialApp(
          title: 'What the heck do we call this app?',
          theme: catppuccinTheme(
            flavorMap[themeName]!,
            context: context,
          ),
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
