import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

import '../common/logger.dart';
import 'router.dart';
import 'theme.dart';

class App extends StatelessWidget {
  const App({
    super.key,
    this.home,
  });

  final Widget? home;

  @override
  Widget build(BuildContext context) {
    title(context) => L10n.of(context).appTitle;

    if (home != null) {
      logDebug('Using static home', name: 'app/app');
      return MaterialApp(
        onGenerateTitle: title,
        theme: appTheme.light,
        darkTheme: appTheme.dark,
        localizationsDelegates: L10n.localizationsDelegates,
        supportedLocales: L10n.supportedLocales,
        home: home,
      );
    }

    logDebug('Using router', name: 'app/app');
    return MaterialApp.router(
      onGenerateTitle: title,
      theme: appTheme.light,
      darkTheme: appTheme.dark,
      localizationsDelegates: L10n.localizationsDelegates,
      supportedLocales: L10n.supportedLocales,
      routerConfig: appRouter,
    );
  }
}
