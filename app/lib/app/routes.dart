/* GENERATED CODE. DO NOT MODIFY */

// ignore_for_file: prefer_relative_imports
import 'package:app/ui/common/icon.dart';
import 'package:app/ui/page/todos.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:go_router/go_router.dart';

final appRoutes = <AppRoute>[
  pageRouteTodosPage
];

final pageRouteTodosPage = AppRoute(
  iconData: AppIcons.todos,
  path: '/todos',
  label: (l10n) => l10n.todos,
  routeBuilder: (context, state) => const TodosPage(),
);

typedef L10nFunction = String Function(L10n);

class AppRoute {
  final IconData iconData;
  final String path;
  final L10nFunction label;
  final GoRouterWidgetBuilder routeBuilder;

  AppRoute({
    required this.iconData,
    required this.path,
    required this.label,
    required this.routeBuilder,
  });
}
