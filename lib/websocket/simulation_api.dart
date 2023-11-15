import 'package:web_socket_client/web_socket_client.dart';
// import 'package:flutter/foundation.dart';
import '../logger.dart';
import 'package:cbor/cbor.dart';

class SimulationAPI {
  static const String _host = 'localhost';
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

    addMessageListener((msg) => l.i(msg));
  }

  // add callbackk to listen to messages
  static void addMessageListener(Function(dynamic) callback) {
    _socket.messages.listen((message) async {
      // decode CBor
      final decoded = await message.transform(cbor.decoder).single;
      callback(decoded);
    });
  }

  static void close() {
    _socket.close();
  }
}
