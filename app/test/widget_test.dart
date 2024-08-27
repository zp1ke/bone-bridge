import 'package:app/app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'ui/page/home.dart';

void main() {
  testWidgets('Home small shows on small device width size',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(400, 200);
    tester.view.devicePixelRatio = 1.0;

    // Build app and trigger a frame.
    await tester.pumpWidget(const App(
      home: HomeTestPage(),
    ));

    expect(find.text(HomeTestPage.smallText), findsOneWidget);
    expect(find.text(HomeTestPage.mediumText), findsNothing);
    expect(find.text(HomeTestPage.largeText), findsNothing);
  });

  testWidgets('Home medium shows on medium device width size',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 200);
    tester.view.devicePixelRatio = 1.0;

    // Build app and trigger a frame.
    await tester.pumpWidget(const App(
      home: HomeTestPage(),
    ));

    expect(find.text(HomeTestPage.smallText), findsNothing);
    expect(find.text(HomeTestPage.mediumText), findsOneWidget);
    expect(find.text(HomeTestPage.largeText), findsNothing);
  });

  testWidgets('Home large shows on large device width size',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1024, 200);
    tester.view.devicePixelRatio = 1.0;

    // Build app and trigger a frame.
    await tester.pumpWidget(const App(
      home: HomeTestPage(),
    ));

    expect(find.text(HomeTestPage.smallText), findsNothing);
    expect(find.text(HomeTestPage.mediumText), findsNothing);
    expect(find.text(HomeTestPage.largeText), findsOneWidget);
  });
}
