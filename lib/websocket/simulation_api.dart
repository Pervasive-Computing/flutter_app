// import 'package:web_socket_client/web_socket_client.dart';
// import 'package:flutter/foundation.dart';
// import 'dart:developer';
import 'dart:core';
import 'dart:convert';
import '../logger.dart';
import 'package:cbor/simple.dart';
import 'package:dartzmq/dartzmq.dart';
import 'package:http/http.dart' as http;

class SimulationAPI {
  // static final simStartingTime = DateTime.parse("2023-12-14T22:00:00Z");
  // static final startingTime = DateTime.now();
  static DateTime _simTimeNow = DateTime.parse("2023-12-14T22:00:00Z");
  static const String _host = 'localhost';
  static const int _portCars = 12000;
  static const int _portTime = 14005;
  static const int _portLampsData = 12001;
  static const int _portLampsLive = 12333;
  static const int lampDataLength = 30;

  static final _uriLamps = Uri(scheme: 'tcp', host: _host, port: _portLampsLive, path: '');
  static final _uriCars = Uri(
    scheme: 'tcp',
    host: _host,
    port: _portCars,
    path: '',
  );
  static final _uriTime = Uri(
    scheme: 'tcp',
    host: _host,
    port: _portTime,
    path: '',
  );

  static final _zContext = ZContext();
  // static final _lampsContext = ZContext();
  // static late final MonitoredZSocket _socket;
  static late final ZSocket _carsSubscriber;
  static late final ZSocket _lampsLightLevelSubscriber;
  static late final ZSocket _timeSubscriber;
  static final _carCallbacks = <Function(dynamic)>[];
  static final _lampCallbacks = <Function(Map<String, double>)>[];
  static final _timeCallbacks = <Function(DateTime)>[];
  // static late final ZSocket _lampsClient;
  // static Map<String, dynamic> _lampData = {};
  // static final Map<int, Completer<Map<String, dynamic>>> _responseCompleters = {};

  static void connect() {
    // CAR STUFF
    // _socket = _zcontext.createMonitoredSocket(SocketType.sub);
    _carsSubscriber = _zContext.createSocket(SocketType.sub);
    _lampsLightLevelSubscriber = _zContext.createSocket(SocketType.sub);
    _timeSubscriber = _zContext.createSocket(SocketType.sub);

    const carTopic = 'cars';
    const lampsTopic = 'light_level';
    const timeTopic = 'time';

    _carsSubscriber.setOption(ZMQ_SUBSCRIBE, carTopic);
    _lampsLightLevelSubscriber.setOption(ZMQ_SUBSCRIBE, lampsTopic);
    _timeSubscriber.setOption(ZMQ_SUBSCRIBE, timeTopic);

    _carsSubscriber.connect(_uriCars.toString());
    _lampsLightLevelSubscriber.connect(_uriLamps.toString());
    _timeSubscriber.connect(_uriTime.toString());

    // USE THIS ON WHEN MONITORED SOCKET IS USED
    // _socket.events.listen((event) {
    //   l.i('Received event ${event.event} with value ${event.value}');
    // });

    _carsSubscriber.payloads.listen((message) {
      var decoded = cbor.decode(message.sublist(carTopic.length, message.length)) as Map;
      for (var callback in _carCallbacks) {
        callback(decoded);
      }
    });

    _lampsLightLevelSubscriber.payloads.listen((message) {
      var decoded = cbor.decode(message.sublist(lampsTopic.length, message.length)) as Map;

      final changes = decoded['changes'] as Map;

      final levels = Map<String, double>.fromEntries((changes).entries.map(
        (e) {
          return MapEntry(e.key.toString(), e.value as double);
        },
      ));

      for (var callback in _lampCallbacks) {
        callback(levels);
      }
    });

    _timeSubscriber.payloads.listen((message) {
      // var decoded = message;
      // message to int
      var decoded = String.fromCharCodes(message.sublist(timeTopic.length, message.length));
      final time = DateTime.fromMillisecondsSinceEpoch(int.parse(decoded) * 1000);
      _simTimeNow = time;
      // l.d('Time: ${time.toString()}');
      for (var callback in _timeCallbacks) {
        callback(time);
      }
    });
  }

  // add callbackk to listen to messages
  static void addCarMessageCallback(Function(dynamic) callback) {
    _carCallbacks.add(callback);
  }

  // add callbackk to listen to messages
  static void addLampsMessageCallback(Function(Map<String, double>) callback) {
    _lampCallbacks.add(callback);
  }

  static Future<List<dynamic>> reqLampData(String lampId) async {
    // var now = DateTime.now();
    // var oneDayAgo = now.subtract(const Duration(hours: 24));
    final simNow = _simTimeNow;
    final simOneDayAgo = simNow.subtract(const Duration(minutes: lampDataLength));

    var uriLamps = Uri(
      scheme: 'http',
      host: _host,
      port: _portLampsData,
      path: 'streetlamp/$lampId/lightlevels',
      queryParameters: {
        'reducer': 'mean',
        'per': 'minute',
        'start': (simOneDayAgo.millisecondsSinceEpoch ~/ 1000).toString(),
        'end': (simNow.millisecondsSinceEpoch ~/ 1000).toString(),
      },
    );

    var response = await http.get(uriLamps, headers: {'Content-Type': 'application/json'});

    List<dynamic> responseData = [];
    if (response.statusCode == 200) {
      // l.d('Response body: ${response.body}, with type ${response.body.runtimeType}');
      responseData = json.decode(response.body);
    } else {
      l.w('Request failed with status: ${response.statusCode}. With body ${response.body}');
    }

    return responseData;
  }

  static DateTime getSimTimeNow() {
    // final deltaTime = DateTime.now().difference(startingTime);
    // return simStartingTime.add(deltaTime);
    return _simTimeNow;
  }

  static void close() {
    _carsSubscriber.close();
    // _lampsClient.close();
  }
}
