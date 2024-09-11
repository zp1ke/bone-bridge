import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:simple_icons/simple_icons.dart';

// https://master--628d031b55e942004ac95df1.chromatic.com/?path=/docs/icons-catalog--page
// https://fonts.google.com/icons
// https://simpleicons.org/
class AppIcons {
  AppIcons._();

  static const IconData about = FluentIcons.info_24_filled;

  static const IconData add = FluentIcons.add_24_filled;

  static const IconData hidePassword = FluentIcons.eye_off_24_filled;

  static const IconData home = FluentIcons.home_24_filled;

  static const Widget loadingSmall = SizedBox(
    height: 18,
    width: 18,
    child: CircularProgressIndicator.adaptive(),
  );

  static const IconData menu = FluentIcons.navigation_24_filled;

  static const IconData name = FluentIcons.person_info_24_filled;

  static const IconData paginationGoFirst =
      FluentIcons.arrow_previous_24_filled;

  static const IconData paginationGoLast = FluentIcons.arrow_next_24_filled;

  static const IconData paginationNext = Icons.arrow_forward_ios_sharp;

  static const IconData paginationPrev = Icons.arrow_back_ios_sharp;

  static const IconData password = FluentIcons.password_24_filled;

  static const IconData profile = FluentIcons.slide_text_person_24_filled;

  static const IconData refresh = FluentIcons.arrow_clockwise_24_filled;

  static const IconData save = FluentIcons.save_24_filled;

  static const IconData share = FluentIcons.share_24_filled;

  static const IconData showPassword = FluentIcons.eye_24_filled;

  static const IconData signOut = FluentIcons.sign_out_24_filled;

  static const IconData summary = FluentIcons.document_24_filled;

  static const IconData todoDescription =
      FluentIcons.text_description_24_filled;

  static const IconData todos = FluentIcons.task_list_square_ltr_24_filled;

  static const IconData user = FluentIcons.person_info_24_filled;

  static const IconData username = FluentIcons.person_24_filled;

  static final Map<IconData, String> brandIconsMap =
      SimpleIcons.values.map((k, v) => MapEntry(v, k));
}
