import 'package:flutter/widgets.dart';

abstract class PageState<T extends StatefulWidget> extends State<T> {
  bool get canAdd;

  bool get canReload;

  void onAdd();

  void onReload();
}
