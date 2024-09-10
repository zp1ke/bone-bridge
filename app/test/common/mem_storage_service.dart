import 'package:app/service/preferences_service.dart';

class MemoryStorageService implements PreferencesService {
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

  @override
  Future clear() {
    _map.clear();
    return Future.value(null);
  }
}
