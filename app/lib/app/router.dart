import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../ui/component/layout.dart';
import '../ui/page/index.dart';
import '../ui/page/page_a.page_route.dart';
import '../ui/page/page_b.page_route.dart';

// https://pedromarquez.dev/blog/2022/9/flutter-code-gen-2
final _routes = <AppRoute>[
  pageRoutePageA,
  pageRoutePageB,
];

// https://pub.dev/documentation/go_router/latest/topics/Configuration-topic.html
final appRouter = GoRouter(
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return AppLayout(routes: _routes, child: child);
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
