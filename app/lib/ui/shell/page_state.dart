import 'package:flutter/widgets.dart';

abstract class PageState<T extends StatefulWidget> extends State<T> {
  void onAdd();

  void onReload();
}
