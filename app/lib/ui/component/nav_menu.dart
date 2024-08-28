import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../app/router.dart';
import '../../common/logger.dart';
import '../../model/auth.dart';
import '../common/icon.dart';

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
    logDebug('Active route: $selectedPath', name: 'ui/component/nav_menu');
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        Consumer<AuthState>(
          builder: (context, authState, _) {
            final auth = authState.auth!;
            final textColor = Theme.of(context).colorScheme.onPrimaryContainer;
            return UserAccountsDrawerHeader(
              accountName: expanded
                  ? Text(
                      auth.fullName ?? auth.username,
                      textScaler: const TextScaler.linear(0.9),
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: textColor,
                      ),
                    )
                  : null,
              accountEmail: expanded
                  ? Text(
                      auth.email,
                      textScaler: const TextScaler.linear(0.8),
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: textColor,
                      ),
                    )
                  : null,
              currentAccountPicture: auth.image != null
                  //? CircleAvatar(backgroundImage: NetworkImage(auth.image!))
                  ? AnimatedContainer(
                      width: expanded ? 130 : 16,
                      height: expanded ? 130 : 16,
                      duration: const Duration(milliseconds: 250),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: textColor,
                        image: DecorationImage(
                          image: NetworkImage(auth.image!),
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                    )
                  : null,
              arrowColor: Theme.of(context).primaryColor,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
              ),
            );
          },
          child: const Center(
            child: CircularProgressIndicator.adaptive(),
          ),
        ),
        _menuItem(
          expanded: expanded,
          label: 'Home',
          icon: AppIcons.home,
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
