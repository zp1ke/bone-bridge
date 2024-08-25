import 'package:flutter/material.dart';

class PageB extends StatelessWidget {
  static const String name = 'b';

  const PageB({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('PAGE B'),
      ),
    );
  }
}
