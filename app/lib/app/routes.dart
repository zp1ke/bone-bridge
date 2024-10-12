/* GENERATED CODE. DO NOT MODIFY */

// ignore_for_file: prefer_relative_imports
import 'package:app/ui/common/icon.dart';
import 'package:app/ui/shell/page_state.dart';
import 'package:app/ui/page/profile/profile.dart';
import 'package:app/ui/page/todos/todos.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:go_router/go_router.dart';

final appRoutes = <AppRoute>[pageRouteProfilePage, pageRouteTodosPage];

final pageRouteProfilePage = AppRoute(
  iconData: AppIcons.profile,
  path: '/profile',
  label: (l10n) => l10n.profile,
  widgetKey: GlobalKey<PageState<ProfilePage>>(),
  routeBuilder: (context, state, key) => ProfilePage(key: key),
);

final pageRouteTodosPage = AppRoute(
  iconData: AppIcons.todos,
  path: '/todos',
  label: (l10n) => l10n.todos,
  widgetKey: GlobalKey<PageState<TodosPage>>(),
  routeBuilder: (context, state, key) => TodosPage(key: key),
);

typedef L10nFunction = String Function(L10n);

typedef RouterWidgetBuilder = Widget Function(
  BuildContext context,
  GoRouterState state,
  Key? key,
);

class AppRoute {
  final IconData iconData;
  final String path;
  final L10nFunction label;
  final Key widgetKey;
  final RouterWidgetBuilder routeBuilder;

  AppRoute({
    required this.iconData,
    required this.path,
    required this.label,
    required this.widgetKey,
    required this.routeBuilder,
  });
}
