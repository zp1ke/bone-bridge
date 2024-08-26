import 'package:flutter/material.dart';

import 'app/router.dart';
import 'app/theme.dart';
import 'platform/common.dart'
    if (dart.library.html) 'platform/web.dart'
    if (dart.library.io) 'platform/common.dart';

void main() {
  setupPlatform();
  runApp(const App());
}

// TODO: https://docs.flutter.dev/ui/accessibility-and-internationalization/internationalization
class App extends StatelessWidget {
  const App({
    super.key,
    this.home,
  });

  final Widget? home;

  @override
  Widget build(BuildContext context) {
    const title = 'TODO';

    if (home != null) {
      debugPrint('Using static home');
      return MaterialApp(
        title: title,
        theme: appTheme.light,
        darkTheme: appTheme.dark,
        home: home,
      );
    }

    debugPrint('Using router');
    return MaterialApp.router(
      title: title,
      theme: appTheme.light,
      darkTheme: appTheme.dark,
      routerConfig: appRouter,
    );
  }
}
