import '../common/selector_provider.dart';
import 'package:flutter/widgets.dart';

const smallDeviceMaxWidth = 640.0;
const mediumDeviceMaxWidth = 768.0;
const largeDeviceMaxWidth = 1024.0;

class AppLayout extends StatelessWidget {
  AppLayout({
    super.key,
    WidgetBuilder? small,
    WidgetBuilder? medium,
    WidgetBuilder? large,
    WidgetBuilder? extraLarge,
  }) : _selectorProvider = SelectorProvider(
          valuesMap: _buildersMap(small, medium, large, extraLarge),
          comparator: (d1, d2) => d1.compareTo(d2),
        );

  final SelectorProvider<Widget, BuildContext, double> _selectorProvider;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final builder = _selectorProvider.builderFor(constraints.maxWidth);
        return builder(context);
      },
    );
  }
}

Map<double, WidgetBuilder> _buildersMap(
  WidgetBuilder? small,
  WidgetBuilder? medium,
  WidgetBuilder? large,
  WidgetBuilder? extraLarge,
) {
  final buildersMap = <double, WidgetBuilder>{};
  if (small != null) {
    buildersMap[smallDeviceMaxWidth] = small;
  }
  if (medium != null) {
    buildersMap[mediumDeviceMaxWidth] = medium;
  }
  if (large != null) {
    buildersMap[largeDeviceMaxWidth] = large;
  }
  if (extraLarge != null) {
    buildersMap[double.maxFinite] = extraLarge;
  }
  return buildersMap;
}
