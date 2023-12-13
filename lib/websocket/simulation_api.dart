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

  static final uriLamps = Uri(
    scheme: 'tcp',
    host: _host,
    port: _portLampsLive,
    path: '',
  );

  static final _zContext = ZContext();
  // static final _lampsContext = ZContext();
  // static late final MonitoredZSocket _socket;
  static late final ZSocket _carsClient;
  static late final ZSocket _lampsClient;
  static final _carCallbacks = <Function(dynamic)>[];
  static final _lampCallbacks = <Function(dynamic)>[];
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
      l.d("decoded: $decoded");
      for (var callback in _lampCallbacks) {
        callback(decoded);
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
  static void addCarMessageListener(Function(dynamic) callback) {
    _carCallbacks.add(callback);
  }

  // add callbackk to listen to messages
  static void addLampsMessageListener(Function(dynamic) callback) {
    _lampCallbacks.add(callback);
  }

  static Future<Map<String, dynamic>> reqLampData(String lampId) async {
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

    var url = Uri.parse('http://localhost:$_portLampsData/lampdata/$lampId');
    var response = await http
        .post(url, body: json.encode(request), headers: {'Content-Type': 'application/json'});

    Map<String, dynamic> responseData = {};
    if (response.statusCode == 200) {
      responseData = json.decode(response.body);
    } else {
      l.w('Request failed with status: ${response.statusCode}.');
    }

    return responseData;

    // var jsonEncoded = jsonEncode(request);
    // _lampsClient.send(jsonEncoded.codeUnits);

    // while (_lampData["id"] != _id) {
    //   // l.d("waiting for lamp data. Previous id: $lampId, previous id: ${_lampData["id"]}");
    //   l.d("waiting for lamp data. request id: $_id, response id: ${_lampData["id"]}");
    //   await Future.delayed(const Duration(milliseconds: 100));
    // }

    // l.w("result: $_lampData");
    // return _lampData;

    // var completer = Completer<Map<String, dynamic>>();

    // StreamSubscription? subscription;
    // subscription = _lampsClient.payloads.listen((message) {
    //   var decoded = jsonDecode(String.fromCharCodes(message));
    //   if (decoded['id'] == _id) {
    //     completer.complete(decoded);
    //     subscription?.cancel(); // Stop listening to further messages
    //   }
    // });

    // return completer.future; // This will complete when the response arrives

    // var completer = Completer<Map<String, dynamic>>();
    // _responseCompleters[_id] = completer;

    // var jsonEncoded = jsonEncode(request);
    // _lampsClient.send(jsonEncoded.codeUnits);

    // return completer.future;
  }

  static void close() {
    _carsClient.close();
    // _lampsClient.close();
  }
}
