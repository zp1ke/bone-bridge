import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../ui/component/layout.dart';
import '../ui/page/index.dart';
import 'routes.dart';

// https://pub.dev/documentation/go_router/latest/topics/Configuration-topic.html
final appRouter = GoRouter(
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return AppLayout(routes: appRoutes, child: child);
      },
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) {
            return const HomePage();
          },
          routes: appRoutes.map((appPage) {
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

  String? get activeNavPath {
    return GoRouterState.of(this).fullPath;
  }
}

class AppRoute {
  final IconData iconData;
  final String path;
  final String label;
  final GoRouterWidgetBuilder routeBuilder;

  AppRoute({
    required this.iconData,
    required this.path,
    required this.label,
    required this.routeBuilder,
  });
}
