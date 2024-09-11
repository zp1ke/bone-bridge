import 'package:flutter/foundation.dart';

import '../state/auth.dart';

abstract class StorageService {
  Future saveFile(
    Auth auth, {
    required String key,
    required String name,
    required Uint8List bytes,
  });

  Future<Uint8List?> getFile({required String key});
}
