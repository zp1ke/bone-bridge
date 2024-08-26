import 'package:flutter/material.dart';

import 'page/router.dart';
import 'platform/common.dart'
    if (dart.library.html) 'platform/web.dart'
    if (dart.library.io) 'platform/common.dart';

void main() {
  setupPlatform();
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
