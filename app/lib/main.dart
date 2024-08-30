import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app/app.dart';
import 'model/auth.dart';
import 'model/todo.dart';
import 'platform/common.dart'
    if (dart.library.html) 'platform/web.dart'
    if (dart.library.io) 'platform/common.dart';
import 'service/dummy_json/dummy_json_service.dart';
import 'service/shared_preferences/shared_preferences_storage_service.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupPlatform();

  // services
  final dummyJsonService = DummyJsonService();
  final sharedPreferencesStorageService = SharedPreferencesStorageService();

  // states
  final authState = await AuthState.create(
    authService: dummyJsonService,
    storageService: sharedPreferencesStorageService,
  );
  final todoState = TodoState(todoService: dummyJsonService);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => authState),
        ChangeNotifierProvider(create: (context) => todoState),
      ],
      child: const App(),
    ),
  );
}
