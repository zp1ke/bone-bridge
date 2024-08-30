import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

import '../../app/router.dart';
import '../../app/routes.dart';
import '../common/icon.dart';
import '../widget/responsive.dart';
import '../widget/split.dart';
import 'app_state.dart';
import 'nav_menu.dart';

class AppLayout extends StatefulWidget {
  final Widget child;

  const AppLayout({
    super.key,
    required this.child,
  });

  @override
  State<AppLayout> createState() => _AppLayoutState();
}

class _AppLayoutState extends State<AppLayout> {
  final GlobalKey<ScaffoldState> key = GlobalKey();

  bool menuExpanded = true;
  bool reloadEnabled = true;

  AppRoute? get appRoute => context.activeAppRoute;

  GlobalKey<PageState>? get routeKey =>
      appRoute?.widgetKey as GlobalKey<PageState>?;

  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
      small: (context) => body(context, withDrawer: true),
      medium: (context) => body(context, menuExpandedSize: 240),
      large: (context) => body(context),
    );
  }

  Widget body(
    BuildContext context, {
    bool withDrawer = false,
    double menuExpandedSize = 280,
  }) {
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
        title: title(),
        leading: IconButton(
          icon: const Icon(AppIcons.menu),
          onPressed: onToggleMenu,
        ),
        actions: [
          if (routeKey != null) refreshAction(),
        ],
      ),
      body: SafeArea(child: body),
      drawer: withDrawer ? Drawer(child: menu(true)) : null,
    );
  }

  Widget title() {
    final titleText = Text(L10n.of(context).appTitle);
    if (appRoute == null) {
      return titleText;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        titleText,
        Text(
          appRoute!.label(L10n.of(context)),
          textScaler: const TextScaler.linear(0.5),
          style: const TextStyle(fontWeight: FontWeight.w400),
        ),
      ],
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
      onNavigation: (path) {
        if (key.currentState!.hasDrawer) {
          key.currentState!.closeDrawer();
        }
        context.navTo(path);
      },
    );
  }

  Widget refreshAction() {
    return IconButton(
      onPressed: reloadEnabled
          ? () {
              setState(() {
                reloadEnabled = false;
              });
              routeKey?.currentState?.onReload();
              Future.delayed(const Duration(seconds: 10), () {
                if (mounted) {
                  setState(() {
                    reloadEnabled = true;
                  });
                }
              });
            }
          : null,
      icon: const Icon(AppIcons.refresh),
    );
  }
}
