abstract class PreferencesService {
  Future saveString({required String key, String? value});

  Future<String?> loadString(String key);

  Future clear();
}
