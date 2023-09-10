import 'package:collector_dash/src/pages/home.dart';
import 'package:collector_dash/src/widgets/keyboard_stream_handler.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const KeyboardStreamHandler(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Collector Dash',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}