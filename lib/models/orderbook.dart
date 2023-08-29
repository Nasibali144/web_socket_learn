final json = {
  "topic": "orderbook",
  "action": "partial",
  "symbol": "xht-usdt",
  "data": {
    "bids": [
      [0.1, 0.1],
    ],
    "asks": [
      [1, 1],
    ],
    "timestamp": "2020-12-15T06:45:27.766Z"
  },
  "time": 1608015328
};

class OrderBook {
  String topic;
  String action;
  String symbol;
  Data data;
  DateTime time;

  OrderBook({
    required this.topic,
    required this.action,
    required this.symbol,
    required this.data,
    required this.time,
  });

  factory OrderBook.fromJson(Map<String, Object?> json) {
    return OrderBook(
      topic: json['topic'] as String,
      action: json['action'] as String,
      symbol: json['symbol'] as String,
      data: Data.fromJson(json['data'] as Map<String, Object?>),
      time: DateTime.fromMillisecondsSinceEpoch(json['time'] as int),
    );
  }
}

class Data {
  List<List<num>> bids;
  List<List<num>> asks;
  DateTime timestamp;

  Data({
    required this.bids,
    required this.asks,
    required this.timestamp,
  });

  factory Data.fromJson(Map<String, Object?> json) {
    return Data(
      bids: (json['bids'] as List).map((e) => List<num>.from(e as List)).toList(),
      asks: (json['asks'] as List).map((e) => List<num>.from(e as List)).toList(),
      timestamp: DateTime.parse(json['timestamp'].toString()),
    );
  }
}
