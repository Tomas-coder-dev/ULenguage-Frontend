import 'package:flutter/material.dart';

class TranslationScreen extends StatelessWidget {
  const TranslationScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Traducción")),
      body: const Center(child: Text("Pantalla Traducción")),
    );
  }
}
