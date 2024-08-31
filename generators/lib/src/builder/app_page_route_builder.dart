import 'dart:async';

import 'package:annotations/annotations.dart';
import 'package:build/build.dart';
import 'package:path/path.dart' as path;
import 'package:source_gen/source_gen.dart';

class AppPageRouteBuilder extends Builder {
  final BuilderOptions options;

  AppPageRouteBuilder({
    required this.options,
  });

  @override
  FutureOr<void> build(BuildStep buildStep) async {
    const typeChecker = TypeChecker.fromRuntime(AppPageRoute);
    final annotated = await getClassesAnnotatedWithTable(
      buildStep: buildStep,
      typeChecker: typeChecker,
    );
    if (annotated.isEmpty) {
      return;
    }

    final assetId = createAssetId(buildStep);
    final filePath = buildStep.inputId.path;
    await buildStep.writeAsString(assetId,
        annotated.map((e) => appPageRouteContent(e, filePath)).join('\n'));
  }

  String appPageRouteContent(AnnotatedElement element, String filePath) {
    final elementName = element.element.displayName;
    final appPageRoute = AppPageRoute(
      path: readString(element, 'path'),
      label: readString(element, 'label'),
      iconCode: readString(element, 'iconCode'),
    );

    return '''
import 'package:app/${filePath.replaceFirst('lib/', '')}';
final pageRoute$elementName = AppRoute(
  iconData: AppIcons.${appPageRoute.iconCode},
  path: '${appPageRoute.path}',
  label: (l10n) => l10n.${appPageRoute.label},
  widgetKey: GlobalKey<PageState<$elementName>>(),
  routeBuilder: (context, state, key) => $elementName(key: key),
);
''';
  }

  String readString(AnnotatedElement element, String field) {
    return element.annotation.read(field).stringValue;
  }

  Future<Iterable<AnnotatedElement>> getClassesAnnotatedWithTable({
    required buildStep,
    required typeChecker,
  }) async {
    final lib = await buildStep.resolver
        .libraryFor(buildStep.inputId, allowSyntaxErrors: true);
    final libraryReader = LibraryReader(lib);
    return libraryReader.annotatedWith(typeChecker);
  }

  AssetId createAssetId(BuildStep buildStep) {
    final filePath = buildStep.inputId.path;
    final fileName =
        '${path.basenameWithoutExtension(filePath)}.page_route.dart';
    final partfile = path.join(path.dirname(filePath), fileName);
    return AssetId(buildStep.inputId.package, partfile);
  }

  @override
  Map<String, List<String>> get buildExtensions => const {
        r'.dart': ['.page_route.dart'],
      };
}
