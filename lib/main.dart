import 'package:bone_bridge/component/layout.dart';
import 'package:flutter/material.dart';

import 'page/index.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TODO',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: AppLayout(
        small: (context) => const PageA(),
        medium: (context) => const PageB(),
      ),
    );
  }
}
