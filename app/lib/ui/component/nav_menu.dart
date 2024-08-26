import 'package:flutter/material.dart';

import '../../app/router.dart';

class NavMenu extends StatelessWidget {
  final bool expanded;
  final List<AppRoute> routes;
  final Function(String) onNavigation;

  const NavMenu({
    super.key,
    required this.expanded,
    required this.routes,
    required this.onNavigation,
  });

  @override
  Widget build(BuildContext context) {
    final selectedPath = context.activeNavPath;
    debugPrint('Active route: $selectedPath');
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        DrawerHeader(
          child:
              expanded ? const Text('Drawer Header') : const Icon(Icons.people),
        ),
        _menuItem(
          expanded: expanded,
          label: 'Home',
          icon: Icons.home_sharp,
          path: '/',
          selected: selectedPath == null || selectedPath == '/',
          onNavigation: onNavigation,
        ),
        const Divider(),
        ...routes.map((route) {
          return _menuItem(
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

  Widget _menuItem({
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
        onTap: !selected ? () => onNavigation(path) : null,
      ),
    );
  }
}
