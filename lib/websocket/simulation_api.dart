// import 'package:web_socket_client/web_socket_client.dart';
// import 'package:flutter/foundation.dart';
// import 'dart:async';
// import 'dart:developer';
import '../logger.dart';
import 'package:cbor/cbor.dart';
import 'package:dartzmq/dartzmq.dart';

class SimulationAPI {
  static const String _host = 'localhost';
  static const int _port = 9001;
  static const String _path = '';

  static final uri = Uri(
    scheme: 'ws',
    host: _host,
    port: _port,
    path: _path,
  );

  static final _zcontext = ZContext();
  static late final ZSocket _socket;
  // late StreamSubscription _subscription;

  static void connect() {
    _socket = _zcontext.createSocket(SocketType.sub);
    _socket.setOption(ZMQ_SUBSCRIBE, "");
    _socket.connect(uri.toString());

    // _socket.events.listen((event) {
    //   l.i(event);
    // });

    // addMessageListener((message) {
    //   l.i(message);
    // });
    _socket.payloads.listen((message) {
      final decoded = cbor.decode(message);
      final map = decoded.toObject();
      // callback(decoded);
      l.i(map.runtimeType);
    });
  }

  // add callbackk to listen to messages
  static void addMessageListener(Function(dynamic) callback) {
    // listen for messages
    _socket.payloads.listen((message) {
      final decoded = cbor.decode(message);
      callback(decoded);
    });
  }

  static void close() {
    _socket.close();
  }
}
