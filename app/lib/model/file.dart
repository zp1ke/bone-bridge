import 'package:flutter/foundation.dart';

class AppFile {
  final String name;
  final String extension;
  final Uint8List bytes;
  final int size;

  AppFile({
    required this.name,
    required this.extension,
    required this.bytes,
    required this.size,
  });
}
