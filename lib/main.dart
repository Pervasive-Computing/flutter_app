import 'package:flutter/material.dart';
import 'home.dart';
import 'themes/themes.dart';
// import '../websocket/simulation_api.dart';
import "package:dart_amqp/dart_amqp.dart";
import "logger.dart";

void main() async {
  // SimulationAPI.connect();

  Client client = Client(
    settings: ConnectionSettings(
      host: "localhost",
      port: 9001,
    ),
  );
  Channel channel = await client.channel();
  Queue queue = await channel.queue("hello");
  Consumer consumer = await queue.consume();
  consumer.listen((AmqpMessage message) {
    // Get the payload as a string
    l.i(" [x] Received string: ${message.payloadAsString}");

    // Or unserialize to json
    l.i(" [x] Received json: ${message.payloadAsJson}");

    // Or just get the raw data as a Uint8List
    l.i(" [x] Received raw: ${message.payload}");

    // The message object contains helper methods for
    // replying, ack-ing and rejecting
    message.reply("world");
  });

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  final _themeNotifier = ValueNotifier('mocha');

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
