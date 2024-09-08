import 'package:get_it/get_it.dart';

import '../service/app_write/app_write_service.dart';
import '../service/auth_service.dart';
import '../service/dummy_json/dummy_json_service.dart';
import '../service/profile_service.dart';
import '../service/shared_preferences/shared_preferences_storage_service.dart';
import '../service/storage_service.dart';
import '../service/todo_service.dart';
import 'logger.dart';

final _getIt = GetIt.instance;

void setupServices() {
  // app-write
  AppWriteService? appWriteService;
  final appWriteConfig = AppWriteConfig.create();
  if (appWriteConfig.isValid) {
    appWriteService = AppWriteService(appWriteConfig);
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
  // profiles-service
  final ProfileService? profileService =
      (appWriteService?.canHandleProfiles ?? false) ? appWriteService! : null;
  logDebug(
    'ProfileService: ${profileService?.runtimeType}',
    name: 'common/locator',
  );
  if (profileService != null) {
    _getIt.registerSingleton<ProfileService>(profileService);
  }
}

T getService<T extends Object>() {
  return _getIt.get<T>();
}

T? getOptionalService<T extends Object>() {
  if (_getIt.isRegistered<T>()) {
    return _getIt.get<T>();
  }
  return null;
}
