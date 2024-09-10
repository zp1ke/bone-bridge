import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';

Future<Uint8List?> pickImage() async {
  final result = await FilePicker.platform.pickFiles(
    allowCompression: false,
    compressionQuality: 90,
    lockParentWindow: true,
    type: FileType.image,
    withData: true,
  );
  if (result != null) {
    return result.files.first.bytes;
  }
  return null;
}
