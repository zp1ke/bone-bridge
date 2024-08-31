import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

import '../../app/router.dart';
import '../../app/routes.dart';
import '../../common/logger.dart';
import '../common/icon.dart';
import '../widget/responsive.dart';
import '../widget/split.dart';
import 'nav_menu.dart';
import 'page_state.dart';

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

  PageState? routeState;
  bool menuExpanded = true;
  bool reloadEnabled = true;

  AppRoute? get appRoute => context.activeAppRoute;

  @override
  void didUpdateWidget(covariant AppLayout oldWidget) {
    super.didUpdateWidget(oldWidget);
    Future.delayed(Duration.zero, initRouteState);
  }

  // FIXME: not working on web accessing directly to url /todos
  void initRouteState({int count = 0}) {
    if (appRoute != null && routeState == null) {
      routeState = (appRoute!.widgetKey as GlobalKey<PageState>?)?.currentState;
      if (routeState != null) {
        setState(() {});
        logDebug('routeState successfully initiated', name: 'ui/shell/layout');
      } else if (count < 5) {
        Future.delayed(
          const Duration(milliseconds: 50),
          () => initRouteState(count: count + 1),
        );
      } else {
        logError('routeState failed to initiate', name: 'ui/shell/layout');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
      small: (context) => body(
        context,
        withDrawer: true,
        withFab: true,
      ),
      medium: (context) => body(
        context,
        menuExpandedSize: 240,
        withAddAction: true,
      ),
      large: (context) => body(
        context,
        withAddAction: true,
      ),
    );
  }

  Widget body(
    BuildContext context, {
    bool withDrawer = false,
    double menuExpandedSize = 280,
    bool withFab = false,
    bool withAddAction = false,
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
          if (withAddAction && (routeState?.canAdd ?? false)) addAction(),
          if (routeState?.canReload ?? false) refreshAction(),
        ],
      ),
      body: SafeArea(child: body),
      drawer: withDrawer ? Drawer(child: menu(true)) : null,
      floatingActionButton:
          withFab && (routeState?.canAdd ?? false) ? fabAddButton() : null,
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

  Widget fabAddButton() {
    return FloatingActionButton(
      mini: true,
      onPressed: () {
        routeState?.onAdd();
      },
      child: const Icon(AppIcons.add),
    );
  }

  Widget addAction() {
    return IconButton(
      onPressed: () {
        routeState?.onAdd();
      },
      icon: const Icon(AppIcons.add),
    );
  }

  Widget refreshAction() {
    return IconButton(
      onPressed: reloadEnabled
          ? () {
              setState(() {
                reloadEnabled = false;
              });
              routeState?.onReload();
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

  @override
  void dispose() {
    routeState = null;
    super.dispose();
  }
}
