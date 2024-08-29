abstract class StorageService {
  Future saveString({required String key, String? value});

  Future<String?> loadString(String key);

  Future clear();
}
