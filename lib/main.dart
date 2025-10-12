import 'package:flutter/material.dart';
import 'screens/welcome_screen.dart';

void main() {
  runApp(const ULenguageApp());
}

class ULenguageApp extends StatelessWidget {
  const ULenguageApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ULenguage',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'SFProDisplay',
        primarySwatch: Colors.red,
        useMaterial3: true,
      ),
      home: const WelcomeScreen(),
    );
  }
}
