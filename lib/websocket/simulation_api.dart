// import 'package:web_socket_client/web_socket_client.dart';
// import 'package:flutter/foundation.dart';
// import 'dart:async';
// import 'dart:developer';
import '../logger.dart';
import 'package:cbor/simple.dart';
import 'package:dartzmq/dartzmq.dart';

class SimulationAPI {
  static const String _host = 'localhost';
  static const int _port = 12000;
  static const String _path = '';

  static final uri = Uri(
    scheme: 'tcp',
    host: _host,
    port: _port,
    path: _path,
  );

  static final _zcontext = ZContext();
  // static late final MonitoredZSocket _socket;
  static late final ZSocket _socket;
  static var callbacks = <Function(dynamic)>[];

  static var lastCallTime = DateTime.now();

  static void connect() {
    // _socket = _zcontext.createMonitoredSocket(SocketType.sub);
    _socket = _zcontext.createSocket(SocketType.sub);
    const topic = 'cars';
    _socket.setOption(ZMQ_SUBSCRIBE, topic);
    _socket.connect(uri.toString());

    // _socket.events.listen((event) {
    //   l.i('Received event ${event.event} with value ${event.value}');
    // });
    _socket.payloads.listen((message) {
      // l.d('Received message: ${message}');
      var decoded = cbor.decode(message.sublist(topic.length, message.length)) as Map;
      // call all callbacks
      for (var callback in callbacks) {
        callback(decoded);
      }
    });
  }

  // add callbackk to listen to messages
  static void addMessageListener(Function(dynamic) callback) {
    // listen for messages
    callbacks.add(callback);
  }

  static void close() {
    _socket.close();
  }
}
