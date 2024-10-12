import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:json_annotation/json_annotation.dart';

class IconDataConverter implements JsonConverter<IconData, String> {
  static const codePointKey = 'codePoint';
  static const fontFamilyKey = 'fontFamily';
  static const fontPackageKey = 'fontPackage';

  const IconDataConverter();

  @override
  IconData fromJson(String json) {
    final map = jsonDecode(json);
    final codePoint = map[codePointKey] as num;
    return IconData(
      codePoint.toInt(),
      fontFamily: map[fontFamilyKey] as String?,
      fontPackage: map[fontPackageKey] as String?,
    );
  }

  @override
  String toJson(IconData value) => jsonEncode(<String, Object>{
        codePointKey: value.codePoint,
        fontFamilyKey: value.fontFamily ?? '',
        fontPackageKey: value.fontPackage ?? '',
      });
}
