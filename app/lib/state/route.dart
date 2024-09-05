import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app/routes.dart';
import '../ui/shell/page_state.dart';

class RouteState extends ChangeNotifier {
  AppRoute? _route;
  bool _adding = false;
  bool _fetching = false;
  bool _canAdd = false;
  bool _canReload = false;

  static RouteState of(BuildContext context, {bool listen = false}) {
    return Provider.of<RouteState>(context, listen: listen);
  }

  AppRoute? get route => _route;

  set route(AppRoute? value) {
    _route = value;
    _adding = false;
    _fetching = false;
  }

  PageState? get pageState =>
      (_route?.widgetKey as GlobalKey<PageState>?)?.currentState;

  bool get processing => _adding || _fetching;

  bool get adding => _adding;

  set adding(bool value) {
    _adding = value;
    notifyListeners();
  }

  bool get fetching => _fetching;

  set fetching(bool value) {
    _fetching = value;
    notifyListeners();
  }

  bool get canAdd => _route != null && _canAdd;

  set canAdd(bool value) {
    _canAdd = value;
    notifyListeners();
  }

  bool get canReload => _route != null && _canReload;

  set canReload(bool value) {
    _canReload = value;
    notifyListeners();
  }

  set canAddAndReload(bool value) {
    _canAdd = value;
    _canReload = value;
    notifyListeners();
  }
}
