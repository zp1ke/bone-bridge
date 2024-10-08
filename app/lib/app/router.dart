import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../common/logger.dart';
import '../state/auth.dart';
import '../state/route.dart';
import '../ui/page/home.dart';
import '../ui/page/profile/public_profile.dart';
import '../ui/page/sign_in.dart';
import '../ui/shell/layout.dart';
import 'route_path.dart';
import 'routes.dart';

// https://pub.dev/documentation/go_router/latest/topics/Configuration-topic.html
final appRouter = GoRouter(
  routes: [
    GoRoute(
      path: RoutePath.signIn.path,
      builder: (context, state) {
        return const SignInPage();
      },
    ),
    GoRoute(
      path: '${RoutePath.profile.path}/:username',
      builder: (context, state) {
        final username = state.pathParameters['username'] ?? '-';
        return PublicProfilePage(username: username);
      },
    ),
    ShellRoute(
      builder: (context, state, child) {
        return AppLayout(child: child);
      },
      routes: [
        GoRoute(
          path: RoutePath.home.path,
          builder: (context, state) {
            return const HomePage();
          },
          routes: appRoutes.map((appRoute) {
            final path = appRoute.path.startsWith('/')
                ? appRoute.path.substring(1)
                : appRoute.path;
            logDebug('Adding route /$path', name: 'app/router');
            return GoRoute(
              path: path,
              builder: (context, state) => appRoute.routeBuilder(
                context,
                state,
                appRoute.widgetKey,
              ),
            );
          }).toList(),
        ),
      ],
      redirect: (context, state) async {
        final routePath = RoutePath.parse(state.matchedLocation);
        final redirectPath = AuthState.of(context).redirectPathFor(routePath);
        final appRoute =
            redirectPath == null ? _appRouteOf(state.matchedLocation) : null;
        RouteState.of(context).route = appRoute;
        return redirectPath?.path;
      },
    ),
  ],
);

extension GoRouterHelper on BuildContext {
  void navTo(String location, {Object? extra}) {
    GoRouter.of(this).go(location, extra: extra);
  }

  void navToPath(RoutePath routePath, {Object? extra}) {
    GoRouter.of(this).go(routePath.path, extra: extra);
  }

  void pop<T extends Object?>([T? result]) {
    GoRouter.of(this).pop(result);
  }

  AppRoute? get activeAppRoute {
    final activePath = GoRouterState.of(this).fullPath;
    return _appRouteOf(activePath);
  }
}

AppRoute? _appRouteOf(String? path) {
  return path != null
      ? appRoutes.where((routePath) {
          return path.startsWith(routePath.path);
        }).firstOrNull
      : null;
}
