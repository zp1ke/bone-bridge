import 'package:flutter/material.dart';

class PageA extends StatelessWidget {
  static const String name = 'a';

  const PageA({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('PAGE A'),
      ),
    );
  }
}
