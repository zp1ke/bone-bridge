import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app/app.dart';
import 'common/locator.dart';
import 'model/auth.dart';
import 'model/route_state.dart';
import 'platform/common.dart'
    if (dart.library.html) 'platform/web.dart'
    if (dart.library.io) 'platform/common.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupPlatform();
  setupServices();

  final authState = await AuthState.create();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => authState),
        ChangeNotifierProvider(create: (context) => RouteState()),
      ],
      child: const App(),
    ),
  );
}
