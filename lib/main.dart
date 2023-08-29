import 'package:flutter/material.dart';
import 'package:web_socket_learn/services/socket_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
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

  @override
  void initState() {
    super.initState();
    _initSocketService();
  }

  String response = '';

  _initSocketService() {
    SocketService.connectSocketChannel();

    SocketService.channel.stream.listen((data) {
      setState(() {
        response = data.toString();
      });
    }, onError: (error) {
      setState(() {
        response = error.toString();
      });
    });
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
          child: Text(
            response,
            style: const TextStyle(fontSize: 22),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    SocketService.closeSocketChannel();
    super.dispose();
  }
}