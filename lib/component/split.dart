import 'package:flutter/material.dart';

class SplitWidget extends StatelessWidget {
  final Widget left;
  final Widget center;
  final double leftWidth;

  const SplitWidget({
    super.key,
    required this.left,
    required this.center,
    required this.leftWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: leftWidth,
          child: left,
        ),
        VerticalDivider(width: 1.0, color: Theme.of(context).dividerColor),
        Expanded(child: center),
      ],
    );
  }
}
