import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:provider/provider.dart';

import '../../app/router.dart';
import '../../model/app_info.dart';
import '../../state/route.dart';
import '../common/icon.dart';
import '../widget/responsive.dart';
import '../widget/split.dart';
import 'menu.dart';

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
  AppInfo? appInfo;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      appInfo = await AppInfo.create();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return BackButtonListener(
      child: ResponsiveWidget(
        small: (context) => body(
          context,
          hasDrawer: true,
          hasFab: true,
        ),
        medium: (context) => body(
          context,
          menuExpandedSize: 240,
          hasAddAction: true,
        ),
        large: (context) => body(
          context,
          hasAddAction: true,
        ),
      ),
      onBackButtonPressed: () {
        RouteState.of(context).route = null;
        return Future.value(false);
      },
    );
  }

  Widget body(
    BuildContext context, {
    bool hasDrawer = false,
    double menuExpandedSize = 280,
    bool hasFab = false,
    bool hasAddAction = false,
  }) {
    return Consumer<RouteState>(builder: (context, routeState, _) {
      final body = hasDrawer
          ? widget.child
          : SplitWidget(
              left: menu(context, menuExpanded),
              center: widget.child,
              leftWidth: menuExpanded ? menuExpandedSize : 52,
            );

      final canAdd = routeState.canAdd && !routeState.adding;
      return Scaffold(
        key: key,
        appBar: AppBar(
          title: title(context, routeState),
          leading: IconButton(
            icon: const Icon(AppIcons.menu),
            onPressed: onToggleMenu,
          ),
          actions: [
            if (hasAddAction && canAdd) addAction(context, routeState),
            if (routeState.canReload) refreshAction(context, routeState),
          ],
        ),
        body: SafeArea(child: body),
        drawer: hasDrawer ? Drawer(child: menu(context, true)) : null,
        floatingActionButton:
            hasFab && canAdd ? fabAddButton(context, routeState) : null,
      );
    });
  }

  Widget title(BuildContext context, RouteState routeState) {
    final titleText = Text(L10n.of(context).appTitle);
    if (routeState.route == null) {
      return titleText;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        titleText,
        Text(
          routeState.route!.label(L10n.of(context)),
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

  Widget menu(BuildContext context, bool expanded) {
    return AppMenu(
      expanded: expanded,
      appInfo: appInfo,
      onNavigation: (path) {
        if (key.currentState!.hasDrawer) {
          key.currentState!.closeDrawer();
        }
        context.navTo(path);
      },
    );
  }

  Widget fabAddButton(BuildContext context, RouteState routeState) {
    return FloatingActionButton(
      onPressed: routeState.pageState?.onAdd,
      child: const Icon(AppIcons.add),
    );
  }

  Widget addAction(BuildContext context, RouteState routeState) {
    return IconButton(
      onPressed: routeState.pageState?.onAdd,
      icon: const Icon(AppIcons.add),
    );
  }

  Widget refreshAction(BuildContext context, RouteState routeState) {
    return IconButton(
      onPressed: !routeState.processing && routeState.canReload
          ? routeState.pageState?.onReload
          : null,
      icon: const Icon(AppIcons.refresh),
    );
  }
}
