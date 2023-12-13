// import 'package:web_socket_client/web_socket_client.dart';
// import 'package:flutter/foundation.dart';
// import 'dart:async';
// import 'dart:developer';
import 'dart:convert';
import '../logger.dart';
import 'package:cbor/simple.dart';
import 'package:dartzmq/dartzmq.dart';

class SimulationAPI {
  static const String _host = 'localhost';
  static const int _portCars = 12000;
  static const int _portLamps = 12001;
  static const String _path = '';
  static int _id = 1;

  static final uriCars = Uri(
    scheme: 'tcp',
    host: _host,
    port: _portCars,
    path: _path,
  );

  static final uriLamps = Uri(
    scheme: 'tcp',
    host: _host,
    port: _portLamps,
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
    _socket.connect(uriCars.toString());

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

  // request = {
  //     "jsonrpc": "2.0",
  //     "method": "lightlevel",
  //     "params": {
  //         "streetlamp": args.streetlamp_id,
  //         "reducer": args.reducer,
  //         "per": args.per,
  //         "from": from_unix_ts,
  //         "to": to_unix_ts,
  //     },
  //     "id": id,
  // }

  static Future<List<dynamic>> getLampData(String lampId) async {
    var client = _zcontext.createSocket(SocketType.req);
    client.connect(uriLamps.toString());

    var now = DateTime.now();
    var oneDayAgo = now.subtract(const Duration(days: 1));

    _id += 1;
    var request = {
      'jsonrpc': '2.0',
      'method': 'lightlevel',
      'params': {
        'streetlamp': lampId,
        'reducer': 'mean',
        'per': 'hour',
        'from': oneDayAgo.millisecondsSinceEpoch ~/ 1000,
        'to': now.millisecondsSinceEpoch ~/ 1000,
      },
      'id': _id,
    };

    var jsonEncoded = jsonEncode(request);

    client.send(jsonEncoded.codeUnits);

    List<dynamic> result = [];

    client.payloads.listen((message) {
      var decoded = jsonDecode(String.fromCharCodes(message));
      l.d('Received message: $decoded');

      result = decoded['result'] as List<dynamic>;

      client.close();
    });

    while (result.isEmpty) {
      await Future.delayed(const Duration(milliseconds: 100));
    }

    return result;
  }
}
