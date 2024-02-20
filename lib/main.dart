import 'package:flutter/material.dart';
import 'package:hackathon_app/bustrack.dart';
import 'package:hackathon_app/bustrack_tw.dart';
import 'package:hackathon_app/sent.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(body: Center(child: HomeScreenst())),
    );
  }
}
