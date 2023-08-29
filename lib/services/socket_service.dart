import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:web_socket_learn/models/orderbook.dart';

class SocketService {
  static const String _baseUrl = "wss://api.hollaex.com/stream";
  final WebSocketChannel channel;

  SocketService() : channel = WebSocketChannel.connect(Uri.parse(_baseUrl));
  // static final _instance = SocketService._();
  // factory SocketService() => _instance;

   void connectSocketChannel ({Operations operation = Operations.subscribe,  Events event = Events.orderbook}) {
    final request = {
      "op": operation.name,
      "args": [event.name],
    };
    if(Operations.unsubscribe != operation) {
      channel.sink.add(jsonEncode(request));
    } else {
      channel.sink.add(jsonEncode(request));
      channel.sink.close(status.goingAway);
    }
  }

  Stream get _stream => channel.stream.asBroadcastStream();

  Stream<OrderBook> get orderbook {
    final streamTransformer = StreamTransformer<dynamic, OrderBook>.fromHandlers(
      handleData: (event, sink) {
        final data = jsonDecode(event);
        if(data is Map && data["topic"] == Events.orderbook.name) {
          try{
            final order = OrderBook.fromJson(data as Map<String, dynamic>);
            sink.add(order);
          } catch (e, s) {
            debugPrint("e: $e, s: $s");
          }
        }
      },
      handleError: (error, stackTrace, sink) {
        debugPrint("Error: $error");
      }
    );

    return _stream.transform(streamTransformer).asBroadcastStream();
  }
}

enum Operations {
  subscribe,
  unsubscribe,
  ping,
}

enum Events {
  orderbook,
  trade,
}