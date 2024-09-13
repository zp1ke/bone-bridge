import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'app/app.dart';
import 'common/locator.dart';
import 'platform/common.dart'
    if (dart.library.html) 'platform/web.dart'
    if (dart.library.io) 'platform/common.dart';
import 'state/auth.dart';
import 'state/route.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  _setupLicenses();
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

void _setupLicenses() {
  LicenseRegistry.addLicense(() async* {
    final map = <String, String>{
      'assets/license.txt': ' Bone Bridge app',
      'assets/fonts/lato/OFL.txt': 'google_fonts',
    };
    for (var entry in map.entries) {
      final license = await rootBundle.loadString(entry.key);
      yield LicenseEntryWithLineBreaks([entry.value], license);
    }
  });
}
