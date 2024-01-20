import 'package:flutter/material.dart';
import 'screens/auth_screen.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: const Color.fromRGBO(33, 33, 33, 1.0),
      ),
      home: const AuthScreen(),
    );
  }
}
