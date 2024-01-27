import 'package:flutter/material.dart';
import 'screens/auth_screen.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color.fromRGBO(33, 33, 33, 1.0),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromRGBO(33, 33, 33, 1.0),
        ),
        textTheme: GoogleFonts.latoTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: AuthScreen(),
    );
  }
}
