import 'package:flutter/material.dart';
import 'package:neuralfit_frontend/view/initial_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Flutter Demo', home: const InitialScreen());
  }
}
