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
    await for (var pageRoute in pageRoutes) {
      final fileContent = await buildStep.readAsString(pageRoute);
      final fileLines = fileContent.split('\n');
      content.add(fileLines.first);
      codeContent.addAll(fileLines.sublist(1));
    }

    if (content.isNotEmpty) {
      content.add('import \'router.dart\';');
      content.add('');
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
}
