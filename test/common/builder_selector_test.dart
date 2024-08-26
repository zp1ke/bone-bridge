import 'package:bone_bridge/common/builder_selector.dart';
import 'package:flutter_test/flutter_test.dart';

typedef StringBuilder = String Function(String context);

void main() {
  test('builderFor with all providers', () {
    const smallKey = 'SMALL';
    const mediumKey = 'MEDIUM';
    const largeKey = 'LARGE';
    const extraLargeKey = 'EXTRA_LARGE';

    final builderSelector = BuilderSelector<String, String, double>(
      valuesMap: <double, StringBuilder>{
        10: (_) => smallKey,
        20: (_) => mediumKey,
        30: (_) => largeKey,
        100: (_) => extraLargeKey,
      },
      comparator: (d1, d2) => (d1 - d2).toInt(),
    );

    final valuesMap = <double, String>{
      8: smallKey,
      11: mediumKey,
      21: largeKey,
      31: extraLargeKey,
    };
    valuesMap.forEach((key, value) {
      final builder = builderSelector.builderFor(key);
      expect(builder(''), equals(value));
    });
  });

  test('builderFor with missing providers', () {
    const smallKey = 'SMALL';
    const largeKey = 'LARGE';

    final builderSelector = BuilderSelector<String, String, double>(
      valuesMap: <double, StringBuilder>{
        10: (_) => smallKey,
        30: (_) => largeKey,
      },
      comparator: (d1, d2) => (d1 - d2).toInt(),
    );

    final valuesMap = <double, String>{
      8: smallKey,
      11: largeKey,
      21: largeKey,
      31: largeKey,
    };
    valuesMap.forEach((key, value) {
      final builder = builderSelector.builderFor(key);
      expect(builder(''), equals(value));
    });
  });
}
