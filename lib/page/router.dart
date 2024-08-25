import 'package:bone_bridge/page/index.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../component/layout.dart';

final _routes = <AppRoute>[
  AppRoute(path: PageA.path, routeBuilder: (context, state) => const PageA()),
  AppRoute(path: PageB.path, routeBuilder: (context, state) => const PageB()),
];

// https://pub.dev/documentation/go_router/latest/topics/Configuration-topic.html
final appRouter = GoRouter(
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return AppLayout(child: child);
      },
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) {
            return const HomePage();
          },
          routes: _routes.map((appPage) {
            final path = appPage.path.startsWith('/')
                ? appPage.path.substring(1)
                : appPage.path;
            debugPrint('Adding route /$path');
            return GoRoute(
              path: path,
              builder: appPage.routeBuilder,
            );
          }).toList(),
        ),
      ],
    ),
  ],
);

extension GoRouterHelper on BuildContext {
  void navTo(String location, {Object? extra}) {
    GoRouter.of(this).go(location, extra: extra);
  }
}

class AppRoute {
  final String path;
  final GoRouterWidgetBuilder routeBuilder;

  AppRoute({required this.path, required this.routeBuilder});
}
