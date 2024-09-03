import 'package:get_it/get_it.dart';

import '../config.dart';
import '../service/app_write/app_write_service.dart';
import '../service/auth_service.dart';
import '../service/dummy_json/dummy_json_service.dart';
import '../service/shared_preferences/shared_preferences_storage_service.dart';
import '../service/storage_service.dart';
import '../service/todo_service.dart';

final _getIt = GetIt.instance;

void setupServices() {
  AppWriteService? appWriteService;
  if (AppConfig.appWriteProjectID.value.isNotEmpty) {
    appWriteService = AppWriteService(
      projectID: AppConfig.appWriteProjectID.value,
    );
  }

  final dummyJsonService = DummyJsonService();

  _getIt.registerSingleton<AuthService>(appWriteService ?? dummyJsonService);
  _getIt.registerSingleton<TodoService>(dummyJsonService);

  _getIt.registerLazySingleton<StorageService>(() {
    return SharedPreferencesStorageService();
  });
}

T getService<T extends Object>() {
  return _getIt.get<T>();
}
