import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:provider/provider.dart';

import '../../app/route_path.dart';
import '../../app/router.dart';
import '../../app/routes.dart';
import '../../common/logger.dart';
import '../../model/auth.dart';
import '../common/alert.dart';
import '../common/icon.dart';

class NavMenu extends StatelessWidget {
  final bool expanded;
  final Function(String) onNavigation;

  const NavMenu({
    super.key,
    required this.expanded,
    required this.onNavigation,
  });

  @override
  Widget build(BuildContext context) {
    final selectedPath = context.activeNavPath;
    final l10n = L10n.of(context);
    logDebug('Active route: $selectedPath', name: 'ui/component/nav_menu');

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              Consumer<AuthState>(
                builder: (context, authState, _) {
                  return _header(context, authState.auth!);
                },
                child: const Center(
                  child: CircularProgressIndicator.adaptive(),
                ),
              ),
              _menuItem(
                expanded: expanded,
                label: l10n.home,
                icon: AppIcons.home,
                path: '/',
                selected: selectedPath == null || selectedPath == '/',
                onNavigation: onNavigation,
              ),
              const Divider(),
              ...appRoutes.map((route) {
                return _menuItem(
                  expanded: expanded,
                  label: route.label(l10n),
                  icon: route.iconData,
                  path: route.path,
                  selected: selectedPath != null &&
                      selectedPath.startsWith(route.path),
                  onNavigation: onNavigation,
                );
              }),
            ],
          ),
        ),
        const Divider(),
        _signOutItem(context),
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
        dense: !expanded,
        contentPadding: !expanded ? EdgeInsets.zero : null,
        selected: selected,
        leading: expanded ? Icon(icon) : null,
        title: expanded ? Text(label) : Icon(icon),
        onTap: !selected ? () => onNavigation(path) : null,
      ),
    );
  }

  Widget _header(BuildContext context, Auth auth) {
    final color = Theme.of(context).colorScheme.onPrimaryContainer;
    final decoration = BoxDecoration(
      color: Theme.of(context).colorScheme.primaryContainer,
    );

    if (!expanded) {
      return DrawerHeader(
        decoration: decoration,
        child: auth.image != null
            ? CircleAvatar(
                radius: 56,
                backgroundImage: Image.network(
                  auth.image!,
                  width: 56,
                  fit: BoxFit.scaleDown,
                ).image,
                backgroundColor: color,
              )
            : const Icon(AppIcons.user),
      );
    }

    return UserAccountsDrawerHeader(
      accountName: Text(
        auth.fullName ?? auth.username,
        textScaler: const TextScaler.linear(0.9),
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: color,
        ),
      ),
      accountEmail: Text(
        auth.email,
        textScaler: const TextScaler.linear(0.8),
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
      currentAccountPicture: auth.image != null
          ? CircleAvatar(
              backgroundImage: Image.network(
                auth.image!,
                fit: BoxFit.cover,
              ).image,
              backgroundColor: color,
            )
          : null,
      arrowColor: Theme.of(context).primaryColor,
      decoration: decoration,
    );
  }

  Widget _signOutItem(BuildContext context) {
    final signOutColor = Theme.of(context).colorScheme.error;
    final signOutIcon = Icon(
      AppIcons.signOut,
      color: signOutColor,
    );

    return ListTile(
      dense: !expanded,
      contentPadding: !expanded ? EdgeInsets.zero : null,
      leading: expanded ? signOutIcon : null,
      title: expanded
          ? Text(
              L10n.of(context).signOut,
              style: TextStyle(color: signOutColor),
            )
          : signOutIcon,
      onTap: () {
        _onSignOut(context);
      },
    );
  }

  void _onSignOut(BuildContext context) {
    showConfirmation(
      context,
      title: L10n.of(context).signOut,
      description: L10n.of(context).signOutConfirmation,
      onOk: () async {
        await AuthState.of(context).signOut();
        if (context.mounted) {
          context.navToPath(RoutePath.signIn);
        }
      },
    );
  }
}
