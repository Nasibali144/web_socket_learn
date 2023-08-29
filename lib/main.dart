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
      home: const MainPage(),
    );
  }
}

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          child: const Text("Home"),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const MyHomePage()));
          },
        ),
      ),
    );
  }
}


class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final SocketService socket;

  @override
  void initState() {
    super.initState();
    socket = SocketService();
    socket.connectSocketChannel(operation: Operations.subscribe, event: Events.orderbook);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Socket"),
      ),
      body: StreamBuilder<OrderBook>(
        stream: socket.orderbook,
        builder: (context, snapshot) {
          if(!snapshot.hasData) {
            return const Center(child: Text("No data"));
          }

          OrderBook order = snapshot.data!;
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Text(order.topic, style: Theme.of(context).textTheme.headlineLarge,),
              Text(order.action, style: Theme.of(context).textTheme.headlineMedium,),
              Text(order.symbol, style: Theme.of(context).textTheme.headlineSmall,),
              Text(order.data.timestamp.toString(), style: Theme.of(context).textTheme.titleLarge,),
              Text("ASKS", style: Theme.of(context).textTheme.titleMedium,),
              ...order.data.asks.map((items) => ListTile(title: Text("${items.first}"), subtitle: Text("${items.last}"),),).toList(),
              Text("Bids", style: Theme.of(context).textTheme.titleMedium,),
              ...order.data.bids.map((items) => ListTile(title: Text("${items.first}"), subtitle: Text("${items.last}"),),).toList(),

            ],
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    socket.connectSocketChannel(operation: Operations.unsubscribe, event: Events.orderbook);
    super.dispose();
  }
}