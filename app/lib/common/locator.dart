import 'package:get_it/get_it.dart';

import '../service/auth_service.dart';
import '../service/dummy_json/dummy_json_service.dart';
import '../service/shared_preferences/shared_preferences_storage_service.dart';
import '../service/storage_service.dart';
import '../service/todo_service.dart';

final _getIt = GetIt.instance;

void setupServices() {
  final dummyJsonService = DummyJsonService();
  _getIt.registerSingleton<AuthService>(dummyJsonService);
  _getIt.registerSingleton<TodoService>(dummyJsonService);

  _getIt.registerLazySingleton<StorageService>(() {
    return SharedPreferencesStorageService();
  });
}

T getService<T extends Object>() {
  return _getIt.get<T>();
}
