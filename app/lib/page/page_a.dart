import 'package:flutter/widgets.dart';

class PageA extends StatelessWidget {
  static const path = '/a';

  const PageA({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('PAGE A'),
    );
  }
}
