import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app/app.dart';
import 'common/impl/dummy_json_service.dart';
import 'model/auth.dart';
import 'platform/common.dart'
    if (dart.library.html) 'platform/web.dart'
    if (dart.library.io) 'platform/common.dart';

void main() {
  setupPlatform();
  final dummyJsonService = DummyJsonService();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthState(
            authService: dummyJsonService,
          ),
        ),
      ],
      child: const App(),
    ),
  );
}
