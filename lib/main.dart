import 'package:flutter/material.dart';
import 'package:flutter_sockets/pages/home.dart';
import 'package:flutter_sockets/pages/status.dart';
import 'package:flutter_sockets/services/socket_service.dart';
import 'package:provider/provider.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => SocketService())],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Material App',
        initialRoute: 'status',
        routes: {'home': (_) => HomePage(), 'status': (_) => StatusPage()},
      ),
    );
  }
}
