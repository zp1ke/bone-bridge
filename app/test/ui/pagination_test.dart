import 'package:app/app/app.dart';
import 'package:app/ui/widget/pagination.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const buttonsKeyPrefix = 'pagination-test';

  testWidgets(
      'Zero based first page active renders correct pages and perform correct actions',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1024, 400);
    tester.view.devicePixelRatio = 1.0;

    var pageChanged = -1;
    await tester.pumpWidget(_createApp(
      PaginationWidget(
        page: 0,
        totalCount: 7,
        pageSize: 2,
        totalPages: 3,
        visiblePages: 2,
        itemLabel: 'test',
        onPageChanged: (value) {
          pageChanged = value;
        },
        onPageSizeChanged: (_) {},
        buttonsKeyPrefix: buttonsKeyPrefix,
      ),
    ));
    // previous button
    const prevButtonKey =
        '$buttonsKeyPrefix-${PaginationWidget.gotoPreviousPageKey}';
    final prevPageButton = find.byKey(const ValueKey(prevButtonKey));
    expect(prevPageButton, findsOneWidget);
    expect(tester.widget<IconButton>(prevPageButton).onPressed, isNull);
    // first page button
    final firstButtonKey = PaginationWidget.buttonPageKey(buttonsKeyPrefix, 1);
    expect(firstButtonKey, endsWith('-1'));
    final firstPageButton = find.byKey(ValueKey(firstButtonKey));
    expect(firstPageButton, findsOneWidget);
    expect(tester.widget<IconButton>(firstPageButton).onPressed, isNull);
    // second page button
    final secondButtonKey = PaginationWidget.buttonPageKey(buttonsKeyPrefix, 2);
    expect(secondButtonKey, endsWith('-2'));
    final secondPageButton = find.byKey(ValueKey(secondButtonKey));
    expect(secondPageButton, findsOneWidget);
    await tester.tap(secondPageButton);
    await tester.pumpAndSettle();
    expect(pageChanged, equals(1));
    // next button
    const nextButtonKey =
        '$buttonsKeyPrefix-${PaginationWidget.gotoNextPageKey}';
    final nextPageButton = find.byKey(const ValueKey(nextButtonKey));
    expect(nextPageButton, findsOneWidget);
    await tester.tap(nextPageButton);
    await tester.pumpAndSettle();
    expect(pageChanged, equals(1));
    // other
    expect(find.text('0'), findsNothing);
    expect(find.text('3'), findsNothing);
  });

  testWidgets(
      'Zero based middle page active renders correct pages and perform correct actions',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1024, 400);
    tester.view.devicePixelRatio = 1.0;

    var pageChanged = -1;
    await tester.pumpWidget(_createApp(
      PaginationWidget(
        page: 3,
        totalCount: 22,
        pageSize: 2,
        totalPages: 7,
        itemLabel: 'test',
        visiblePages: 3,
        onPageChanged: (value) {
          pageChanged = value;
        },
        onPageSizeChanged: (_) {},
        buttonsKeyPrefix: buttonsKeyPrefix,
      ),
    ));
    // first page button
    const firstPageButtonKey =
        '$buttonsKeyPrefix-${PaginationWidget.gotoFirstPageKey}';
    final firstPageButton = find.byKey(const ValueKey(firstPageButtonKey));
    expect(firstPageButton, findsOneWidget);
    await tester.tap(firstPageButton);
    await tester.pumpAndSettle();
    expect(pageChanged, equals(0));
    // previous button
    const prevButtonKey =
        '$buttonsKeyPrefix-${PaginationWidget.gotoPreviousPageKey}';
    final prevPageButton = find.byKey(const ValueKey(prevButtonKey));
    expect(prevPageButton, findsOneWidget);
    await tester.tap(prevPageButton);
    await tester.pumpAndSettle();
    expect(pageChanged, equals(2));
    // no first page visible
    expect(find.text('1'), findsNothing);
    // third page button
    final thirdButtonKey = PaginationWidget.buttonPageKey(buttonsKeyPrefix, 3);
    expect(thirdButtonKey, endsWith('-3'));
    final thirdPageButton = find.byKey(ValueKey(thirdButtonKey));
    expect(thirdPageButton, findsOneWidget);
    await tester.tap(thirdPageButton);
    await tester.pumpAndSettle();
    expect(pageChanged, equals(2));
    // fifth page button
    final fifthButtonKey = PaginationWidget.buttonPageKey(buttonsKeyPrefix, 5);
    expect(fifthButtonKey, endsWith('-5'));
    final fifthPageButton = find.byKey(ValueKey(fifthButtonKey));
    expect(fifthPageButton, findsOneWidget);
    await tester.tap(fifthPageButton);
    await tester.pumpAndSettle();
    expect(pageChanged, equals(4));
    // no last page visible
    expect(find.text('7'), findsNothing);
    // next button
    const nextButtonKey =
        '$buttonsKeyPrefix-${PaginationWidget.gotoNextPageKey}';
    final nextPageButton = find.byKey(const ValueKey(nextButtonKey));
    expect(nextPageButton, findsOneWidget);
    await tester.tap(nextPageButton);
    await tester.pumpAndSettle();
    expect(pageChanged, equals(4));
    // last page button
    const lastPageButtonKey =
        '$buttonsKeyPrefix-${PaginationWidget.gotoLastPageKey}';
    final lastPageButton = find.byKey(const ValueKey(lastPageButtonKey));
    expect(lastPageButton, findsOneWidget);
    await tester.tap(lastPageButton);
    await tester.pumpAndSettle();
    expect(pageChanged, equals(6));
    // other
    expect(find.text('0'), findsNothing);
  });
}

Widget _createApp(PaginationWidget widget) => App(
      home: Scaffold(
        body: Center(child: widget),
      ),
    );
