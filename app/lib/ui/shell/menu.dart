import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:provider/provider.dart';

import '../../app/route_path.dart';
import '../../app/router.dart';
import '../../app/routes.dart';
import '../../model/app_info.dart';
import '../../state/auth.dart';
import '../../state/route.dart';
import '../common/alert.dart';
import '../common/icon.dart';

class AppMenu extends StatelessWidget {
  final bool expanded;
  final AppInfo? appInfo;
  final Function(String) onNavigation;

  const AppMenu({
    super.key,
    required this.expanded,
    required this.appInfo,
    required this.onNavigation,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<RouteState>(builder: (context, routeState, _) {
      final l10n = L10n.of(context);
      return SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  Consumer<AuthState>(
                    builder: (context, authState, child) {
                      if (authState.auth != null) {
                        return _header(context, authState.auth!);
                      }
                      return child!;
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
                    selected: routeState.route == null,
                    onNavigation: onNavigation,
                  ),
                  const Divider(),
                  ...appRoutes.map((route) {
                    return _menuItem(
                      expanded: expanded,
                      label: route.label(l10n),
                      icon: route.iconData,
                      path: route.path,
                      selected: routeState.route?.path.startsWith(route.path) ??
                          false,
                      onNavigation: onNavigation,
                    );
                  }),
                ],
              ),
            ),
            if (appInfo != null) const Divider(),
            if (appInfo != null) _aboutItem(context),
            const Divider(),
            _signOutItem(context),
          ],
        ),
      );
    });
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

    final imageUrl = auth.image ?? auth.gravatarUrl;

    if (!expanded) {
      return DrawerHeader(
        decoration: decoration,
        child: CircleAvatar(
          radius: 56,
          backgroundImage: Image.network(
            imageUrl,
            width: 56,
            fit: BoxFit.fitWidth,
          ).image,
          backgroundColor: color,
        ),
      );
    }

    return UserAccountsDrawerHeader(
      accountName: Text(
        auth.fullName ?? auth.username,
        textScaler: const TextScaler.linear(0.95),
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: color,
        ),
      ),
      accountEmail: Text(
        auth.email,
        textScaler: const TextScaler.linear(0.9),
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
      currentAccountPicture: CircleAvatar(
        backgroundImage: Image.network(
          imageUrl,
          fit: BoxFit.cover,
        ).image,
        backgroundColor: color,
      ),
      arrowColor: Theme.of(context).primaryColor,
      decoration: decoration,
    );
  }

  Widget _aboutItem(BuildContext context) {
    final color = Theme.of(context).disabledColor;
    final icon = Icon(
      AppIcons.about,
      color: color,
    );

    return ListTile(
      dense: !expanded,
      contentPadding: !expanded ? EdgeInsets.zero : null,
      leading: expanded ? icon : null,
      title: expanded
          ? Text(
              '${L10n.of(context).appTitle} v${appInfo?.version}',
              style: TextStyle(color: color),
            )
          : icon,
      onTap: () => _showLicenses(context),
    );
  }

  Widget _signOutItem(BuildContext context) {
    final color = Theme.of(context).colorScheme.error;
    final icon = Icon(
      AppIcons.signOut,
      color: color,
    );

    return ListTile(
      dense: !expanded,
      contentPadding: !expanded ? EdgeInsets.zero : null,
      leading: expanded ? icon : null,
      title: expanded
          ? Text(
              L10n.of(context).signOut,
              style: TextStyle(color: color),
            )
          : icon,
      onTap: () {
        _onSignOut(context);
      },
    );
  }

  void _showLicenses(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AboutDialog(
        applicationIcon: const Icon(AppIcons.about),
        applicationName: L10n.of(context).appTitle,
        applicationVersion: appInfo?.version,
      ),
    );
  }

  void _onSignOut(BuildContext context) {
    showConfirmation(
      context,
      title: L10n.of(context).signOut,
      description: L10n.of(context).signOutConfirmation,
      onOk: () async {
        await AuthState.signOut(context);
        if (context.mounted) {
          context.navToPath(RoutePath.signIn);
        }
      },
    );
  }
}
