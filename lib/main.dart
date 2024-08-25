import 'package:flutter/material.dart';

import 'page/router.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({
    super.key,
    this.home,
  });

  final Widget? home;

  @override
  Widget build(BuildContext context) {
    const title = 'TODO';
    final theme = ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
      useMaterial3: true,
    );

    if (home != null) {
      debugPrint('Using static home');
      return MaterialApp(
        title: title,
        theme: theme,
        home: home,
      );
    }

    debugPrint('Using router');
    return MaterialApp.router(
      title: title,
      theme: theme,
      routerConfig: appRouter,
    );
  }
}
