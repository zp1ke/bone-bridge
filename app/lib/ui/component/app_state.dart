import 'package:flutter/widgets.dart';

abstract class AppState<T extends StatefulWidget> extends State<T> {
  void onReload();
}
