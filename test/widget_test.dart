import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:bone_bridge/main.dart';

void main() {
  testWidgets('PageA shows on small device width size',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(400, 200);
    tester.view.devicePixelRatio = 1.0;

    // Build our app and trigger a frame.
    await tester.pumpWidget(const App());

    expect(find.text('PAGE A'), findsOneWidget);
    expect(find.text('PAGE B'), findsNothing);
  });

  testWidgets('PageB shows on medium device width size',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 200);
    tester.view.devicePixelRatio = 1.0;

    // Build our app and trigger a frame.
    await tester.pumpWidget(const App());

    expect(find.text('PAGE B'), findsOneWidget);
    expect(find.text('PAGE A'), findsNothing);
  });
}
