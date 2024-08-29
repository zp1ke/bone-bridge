import 'package:shared_preferences/shared_preferences.dart';

import '../storage_service.dart';

class SharedPreferencesStorageService implements StorageService {
  final SharedPreferencesAsync _asyncPrefs;

  SharedPreferencesStorageService() : _asyncPrefs = SharedPreferencesAsync();

  @override
  Future<String?> loadString(String key) {
    return _asyncPrefs.getString(key);
  }

  @override
  Future saveString({required String key, String? value}) {
    if (value != null) {
      return _asyncPrefs.setString(key, value);
    }
    return _asyncPrefs.remove(key);
  }

  @override
  Future clear() {
    return _asyncPrefs.clear();
  }
}
