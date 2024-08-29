import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

import '../../app/router.dart';
import '../common/icon.dart';
import 'nav_menu.dart';
import 'responsive.dart';
import 'split.dart';

class AppLayout extends StatefulWidget {
  final List<AppRoute> routes;
  final Widget child;

  const AppLayout({
    super.key,
    required this.routes,
    required this.child,
  });

  @override
  State<AppLayout> createState() => _AppLayoutState();
}

class _AppLayoutState extends State<AppLayout> {
  final GlobalKey<ScaffoldState> key = GlobalKey();
  bool menuExpanded = true;

  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
      small: (context) => body(context, withDrawer: true),
      medium: (context) => body(context, menuExpandedSize: 240),
      large: (context) => body(context),
    );
  }

  Widget body(BuildContext context,
      {bool withDrawer = false, double menuExpandedSize = 280}) {
    final body = withDrawer
        ? widget.child
        : SplitWidget(
            left: menu(menuExpanded),
            center: widget.child,
            leftWidth: menuExpanded ? menuExpandedSize : 52,
          );

    return Scaffold(
      key: key,
      appBar: AppBar(
        title: Text(L10n.of(context).appTitle),
        leading: IconButton(
          icon: const Icon(AppIcons.menu),
          onPressed: onToggleMenu,
        ),
      ),
      body: SafeArea(child: body),
      drawer: withDrawer ? Drawer(child: menu(true)) : null,
    );
  }

  void onToggleMenu() {
    if (key.currentState!.hasDrawer) {
      key.currentState!.openDrawer();
    } else {
      setState(() {
        menuExpanded = !menuExpanded;
      });
    }
  }

  Widget menu(bool expanded) {
    return NavMenu(
      expanded: expanded,
      routes: widget.routes,
      onNavigation: (path) {
        if (key.currentState!.hasDrawer) {
          key.currentState!.closeDrawer();
        }
        context.navTo(path);
      },
    );
  }
}
