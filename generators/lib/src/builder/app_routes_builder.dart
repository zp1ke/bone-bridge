import 'package:build/build.dart';
import 'package:glob/glob.dart';

class AppRoutesBuilder implements Builder {
  @override
  Future<void> build(BuildStep buildStep) async {
    final pageRoutes = buildStep.findAssets(Glob('**/*.page_route.dart'));

    final content = <String>[
      '/* GENERATED CODE. DO NOT MODIFY */',
      '',
      'import \'package:flutter/material.dart\';',
      '',
    ];
    final codeContent = <String>[];
    final routes = <String>[];
    await for (var pageRoute in pageRoutes) {
      final fileContent = await buildStep.readAsString(pageRoute);
      final fileLines = fileContent.split('\n');
      content.add(fileLines.first);
      codeContent.addAll(fileLines.sublist(1));
      routes.addAll(extractRoute(fileContent));
    }

    if (content.isNotEmpty) {
      content.add('''
import 'router.dart';

final appRoutes = <AppRoute>[
  ${routes.join(',\n  ')}
];
''');
      content.addAll(codeContent);
      buildStep.writeAsString(
          AssetId(buildStep.inputId.package, 'lib/app/routes.dart'),
          content.join('\n'));
    }
  }

  @override
  final buildExtensions = const {
    r'$lib$': ['app/routes.dart']
  };

  Iterable<String> extractRoute(String content) {
    const startKey = 'final ';
    const endKey = ' =';

    final routes = <String>[];

    var startIndex = content.indexOf(startKey);
    while (startIndex >= 0) {
      final endIndex = content.indexOf(endKey, startIndex);
      if (endIndex > 0) {
        routes.add(content.substring(startIndex + startKey.length, endIndex));
        startIndex = content.indexOf(startKey, endIndex);
      } else {
        startIndex = -1;
      }
    }
    return routes;
  }
}
