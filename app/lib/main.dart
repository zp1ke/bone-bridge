import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app/app.dart';
import 'model/auth.dart';
import 'platform/common.dart'
    if (dart.library.html) 'platform/web.dart'
    if (dart.library.io) 'platform/common.dart';
import 'service/impl/dummy_json_service.dart';
import 'service/impl/shared_preferences_storage_service.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  setupPlatform();
  final dummyJsonService = DummyJsonService();
  final sharedPreferencesStorageService = SharedPreferencesStorageService();
  final authState = await AuthState.create(
    authService: dummyJsonService,
    storageService: sharedPreferencesStorageService,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => authState,
        ),
      ],
      child: const App(),
    ),
  );
}
