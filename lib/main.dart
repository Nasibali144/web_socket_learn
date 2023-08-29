import 'package:flutter/material.dart';
import 'package:web_socket_learn/models/orderbook.dart';
import 'package:web_socket_learn/services/socket_service.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final socket = SocketService();

  @override
  void initState() {
    super.initState();
    socket.connectSocketChannel(operation: Operations.subscribe, event: Events.orderbook);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Socket"),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: StreamBuilder<OrderBook>(
            stream: socket.orderbook,
            builder: (context, snapshot) {
              debugPrint("Stream Type: ${socket.orderbook.isBroadcast}");
              return Text("${snapshot.data?.topic}");
            },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    socket.connectSocketChannel(operation: Operations.unsubscribe);
    super.dispose();
  }
}