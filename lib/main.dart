import 'package:flutter/material.dart';
import 'home.dart';
import 'themes/themes.dart';
import '../websocket/simulation_api.dart';
import 'logger.dart';
import 'package:dartzmq/dartzmq.dart';
// import 'package:cbor/cbor.dart';
import 'package:cbor/simple.dart';
import 'dart:convert';
import 'package:protobuf/protobuf.dart';

void main() {
  l.w("Starting app");
  ZContext _context = ZContext();
  // late MonitoredZSocket _socket = _context.createMonitoredSocket(SocketType.sub);
  ZSocket _socket = _context.createSocket(SocketType.sub);
  _socket.setOption(ZMQ_SUBSCRIBE, "");
  // ZMonitor _monitor = ZMonitor(
  //   context: _context,
  //   socket: _socket,
  // );

  _socket.connect('tcp://localhost:9001');

  // _monitor.events.listen((event) {
  //   l.w("Listening on events");
  //   l.i(event);
  // });

  // listen on status
  _socket.payloads.listen((payload) {
    final decoded = cbor.decode(payload) as Map;
    l.i(decoded);
  });
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

  // construvtor
  MyAppState() {
    // _monitor = ZMonitor(
    //   context: _context,
    //   socket: _socket,
    // );

    // // listen on payloads
    // _socket.payloads.listen((payload) {
    //   l.i(payload);
    // });

    // // listen on messages
    // _socket.messages.listen((message) {
    //   l.i(message);
    // });
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
