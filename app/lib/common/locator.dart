import 'package:get_it/get_it.dart';

import '../config.dart';
import '../service/app_write/app_write_service.dart';
import '../service/auth_service.dart';
import '../service/dummy_json/dummy_json_service.dart';
import '../service/shared_preferences/shared_preferences_storage_service.dart';
import '../service/storage_service.dart';
import '../service/todo_service.dart';
import 'logger.dart';

final _getIt = GetIt.instance;

void setupServices() {
  // app-write
  AppWriteService? appWriteService;
  if (AppConfig.appWriteProjectID.isNotEmpty) {
    // TODO: appwrite custom config
    appWriteService = AppWriteService(
      projectID: AppConfig.appWriteProjectID,
      todosDatabaseID: AppConfig.appWriteTodosDatabaseID,
      todosCollectionID: AppConfig.appWriteTodosCollectionID,
    );
  }
  // dummy-json
  final dummyJsonService = DummyJsonService();
  // auth-service
  final AuthService authService = appWriteService ?? dummyJsonService;
  logDebug(
    'AuthService: ${authService.runtimeType}',
    name: 'common/locator',
  );
  _getIt.registerSingleton<AuthService>(authService);
  // todos-service
  final TodoService todoService = (appWriteService?.canHandleTodos ?? false)
      ? appWriteService!
      : dummyJsonService;
  logDebug(
    'TodoService: ${todoService.runtimeType}',
    name: 'common/locator',
  );
  _getIt.registerSingleton<TodoService>(todoService);
  // storage-service
  _getIt.registerLazySingleton<StorageService>(() {
    final storageService = SharedPreferencesStorageService();
    logDebug(
      'StorageService: ${storageService.runtimeType}',
      name: 'common/locator',
    );
    return storageService;
  });
}

T getService<T extends Object>() {
  return _getIt.get<T>();
}
