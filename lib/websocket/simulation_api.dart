// import 'package:web_socket_client/web_socket_client.dart';
// import 'package:flutter/foundation.dart';
// import 'dart:developer';
import 'dart:async';
import 'dart:convert';
import '../logger.dart';
import 'package:cbor/simple.dart';
import 'package:dartzmq/dartzmq.dart';
import 'package:http/http.dart' as http;

class SimulationAPI {
  static const String _host = 'localhost';
  static const int _portCars = 12000;
  static const int _portLampsData = 12001;
  static const int _portLampsLive = 12333;
  static int _id = 1;

  static final uriCars = Uri(
    scheme: 'tcp',
    host: _host,
    port: _portCars,
    path: '',
  );

  static final uriLamps = Uri(scheme: 'tcp', host: _host, port: _portLampsLive, path: '');

  static final _zContext = ZContext();
  // static final _lampsContext = ZContext();
  // static late final MonitoredZSocket _socket;
  static late final ZSocket _carsClient;
  static late final ZSocket _lampsClient;
  static final _carCallbacks = <Function(dynamic)>[];
  static final _lampCallbacks = <Function(Map<String, double>)>[];
  // static late final ZSocket _lampsClient;
  // static Map<String, dynamic> _lampData = {};
  // static final Map<int, Completer<Map<String, dynamic>>> _responseCompleters = {};

  static void connect() {
    // CAR STUFF
    // _socket = _zcontext.createMonitoredSocket(SocketType.sub);
    _carsClient = _zContext.createSocket(SocketType.sub);
    _lampsClient = _zContext.createSocket(SocketType.sub);
    const carTopic = 'cars';
    const lampsTopic = 'light_level';
    _carsClient.setOption(ZMQ_SUBSCRIBE, carTopic);
    _lampsClient.setOption(ZMQ_SUBSCRIBE, lampsTopic);
    _carsClient.connect(uriCars.toString());
    _lampsClient.connect(uriLamps.toString());

    // USE THIS ON WHEN MONITORED SOCKET IS USED
    // _socket.events.listen((event) {
    //   l.i('Received event ${event.event} with value ${event.value}');
    // });

    _carsClient.payloads.listen((message) {
      var decoded = cbor.decode(message.sublist(carTopic.length, message.length)) as Map;
      for (var callback in _carCallbacks) {
        callback(decoded);
      }
    });

    _lampsClient.payloads.listen((message) {
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

    // LAMP STUFF
    // _lampsClient = _lampsContext.createSocket(SocketType.req);
    // _lampsClient.connect(uriLamps.toString());

    // // _lampsClient.payloads.listen((message) {
    // //   var decoded = jsonDecode(String.fromCharCodes(message));
    // //   l.d('Received message: $decoded');

    // //   _lampData = decoded as Map<String, dynamic>;
    // // });

    // _lampsClient.payloads.listen((message) {
    //   var decoded = jsonDecode(String.fromCharCodes(message));
    //   int responseId = decoded['id'];
    //   _responseCompleters[responseId]?.complete(decoded);
    //   _responseCompleters.remove(responseId);
    // });
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
    var now = DateTime.now();
    var oneDayAgo = now.subtract(const Duration(minutes: 24));

    var uriLamps = Uri(
      scheme: 'http',
      host: _host,
      port: _portLampsData,
      path: 'streetlamp/$lampId/lightlevels',
      queryParameters: {
        'reducer': 'mean',
        'per': 'minute',
        'start': (oneDayAgo.millisecondsSinceEpoch ~/ 1000).toString(),
        'end': (now.millisecondsSinceEpoch ~/ 1000).toString(),
      },
    );

    var response = await http.get(uriLamps, headers: {'Content-Type': 'application/json'});

    List<dynamic> responseData = [];
    if (response.statusCode == 200) {
      responseData = json.decode(response.body);
    } else {
      l.w('Request failed with status: ${response.statusCode}.');
    }

    return responseData;
  }

  static void close() {
    _carsClient.close();
    // _lampsClient.close();
  }
}
