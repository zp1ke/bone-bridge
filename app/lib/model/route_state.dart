import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app/routes.dart';
import '../ui/shell/page_state.dart';

class RouteState extends ChangeNotifier {
  AppRoute? route;

  bool _fetching = false;
  bool _canAdd = false;
  bool _canReload = false;

  static RouteState of(BuildContext context, {bool listen = false}) {
    return Provider.of<RouteState>(context, listen: listen);
  }

  PageState? get pageState =>
      (route?.widgetKey as GlobalKey<PageState>?)?.currentState;

  bool get fetching => _fetching;

  set fetching(bool value) {
    _fetching = value;
    notifyListeners();
  }

  bool get canAdd => route != null && _canAdd;

  set canAdd(bool value) {
    _canAdd = value;
    notifyListeners();
  }

  bool get canReload => route != null && _canReload;

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
