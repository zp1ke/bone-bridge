import 'package:bone_bridge/component/responsive.dart';
import 'package:bone_bridge/component/split.dart';
import 'package:flutter/material.dart';

import '../page/router.dart';

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
      medium: (context) => body(context),
      large: (context) => body(context),
    );
  }

  Widget body(BuildContext context, {bool withDrawer = false}) {
    var body = widget.child;
    if (!withDrawer) {
      body = SplitWidget(
        left: menu(menuExpanded),
        center: body,
        leftWidth: menuExpanded ? 240 : 52,
      );
    }

    return Scaffold(
      key: key,
      appBar: AppBar(
        title: const Text('TODO'),
        elevation: 1,
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: onToggleMenu,
            );
          },
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
    final selectedPath = context.activeNavPath;
    debugPrint('Active route: $selectedPath');
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        DrawerHeader(
          child:
              expanded ? const Text('Drawer Header') : const Icon(Icons.people),
        ),
        menuItem(
          expanded: expanded,
          label: 'Home',
          icon: Icons.home_sharp,
          path: '/',
          selected: selectedPath == null || selectedPath == '/',
          onNavigation: onNavigation,
        ),
        const Divider(),
        ...widget.routes.map((route) {
          return menuItem(
            expanded: expanded,
            label: route.label,
            icon: route.iconData,
            path: route.path,
            selected:
                selectedPath != null && selectedPath.startsWith(route.path),
            onNavigation: onNavigation,
          );
        }),
      ],
    );
  }

  void onNavigation(String path) {
    if (key.currentState!.hasDrawer) {
      key.currentState!.closeDrawer();
    }
    context.navTo(path);
  }

  Widget menuItem({
    required bool expanded,
    required String label,
    required IconData icon,
    required String path,
    required bool selected,
    required Function(String) onNavigation,
  }) {
    return Tooltip(
      message: label,
      waitDuration: Duration(milliseconds: selected ? 1000 : 600),
      child: ListTile(
        selected: selected,
        leading: expanded ? Icon(icon) : null,
        title: expanded ? Text(label) : Icon(icon),
        onTap: !selected
            ? () {
                onNavigation(path);
              }
            : null,
      ),
    );
  }
}
