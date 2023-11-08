import 'package:web_socket_client/web_socket_client.dart';
// import 'package:flutter/foundation.dart';
import '../logger.dart';

class SimulationAPI {
  static const String _host = '127.0.0.1';
  static const int _port = 9001;
  static const String _path = '/cars';

  static final Uri _uri = Uri(
    scheme: 'ws',
    host: _host,
    port: _port,
    path: _path,
  );

  static final WebSocket _socket = WebSocket(_uri);

  static void connect() {
    _socket.connection.listen((state) => l.i('state: "$state" on "$_uri"'));

    _socket.messages.listen((message) {
      l.i('message: "$message"');
    });
  }

  // add callbackk to listen to messages
  static void addMessageListener(Function(dynamic) callback) {
    _socket.messages.listen((message) {
      callback(message);
    });
  }

  static void close() {
    _socket.close();
  }
}
