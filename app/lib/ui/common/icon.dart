import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';

// https://master--628d031b55e942004ac95df1.chromatic.com/?path=/docs/icons-catalog--page
// https://fonts.google.com/icons
class AppIcons {
  AppIcons._();

  static const IconData hidePassword = FluentIcons.eye_off_24_filled;

  static const IconData home = FluentIcons.home_24_filled;

  static const Widget loadingSmall = SizedBox(
    height: 18,
    width: 18,
    child: CircularProgressIndicator(),
  );

  static const IconData menu = FluentIcons.navigation_24_filled;

  static const IconData password = FluentIcons.password_24_filled;

  static const IconData showPassword = FluentIcons.eye_24_filled;

  static const IconData user = FluentIcons.person_info_24_filled;

  static const IconData username = FluentIcons.person_24_filled;
}
