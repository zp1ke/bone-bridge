import 'package:flutter/material.dart';

import '../../common/builder_selector.dart';

const smallDeviceMaxWidth = 640.0;
const mediumDeviceMaxWidth = 992.0;
const largeDeviceMaxWidth = 1200.0;

class ResponsiveWidget extends StatelessWidget {
  ResponsiveWidget({
    super.key,
    WidgetBuilder? small,
    WidgetBuilder? medium,
    WidgetBuilder? large,
    WidgetBuilder? extraLarge,
  }) : _builderSelector = BuilderSelector(
          valuesMap: _buildersMap(small, medium, large, extraLarge),
          comparator: (v1, v2) => (v1 - v2).toInt(),
        );

  final BuilderSelector<Widget, BuildContext, double> _builderSelector;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final builder = _builderSelector.builderFor(constraints.maxWidth);
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
  final map = <double, WidgetBuilder?>{
    smallDeviceMaxWidth: small,
    mediumDeviceMaxWidth: medium,
    largeDeviceMaxWidth: large,
    double.maxFinite: extraLarge,
  };
  map.removeWhere((_, builder) => builder == null);
  return map.cast();
}
