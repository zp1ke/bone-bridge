import 'package:file_picker/file_picker.dart';

import '../../model/file.dart';

Future<AppFile?> pickImage() async {
  final result = await FilePicker.platform.pickFiles(
    allowCompression: false,
    compressionQuality: 90,
    lockParentWindow: true,
    type: FileType.image,
    withData: true,
  );
  if (result != null) {
    final file = result.files.first;
    return AppFile(
      name: file.name,
      extension: file.extension!,
      bytes: file.bytes!,
      size: file.size,
    );
  }
  return null;
}
