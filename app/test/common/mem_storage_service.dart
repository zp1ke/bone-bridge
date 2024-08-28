import 'package:app/service/storage_service.dart';

class MemoryStorageService implements StorageService {
  final _map = <String, String>{};

  @override
  Future<String?> loadString(String key) {
    return Future.value(_map[key]);
  }

  @override
  Future saveString({required String key, String? value}) {
    if (value != null) {
      _map[key] = value;
    } else {
      _map.remove(key);
    }
    return Future.value(null);
  }
}
