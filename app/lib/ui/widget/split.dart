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
        AnimatedContainer(
          width: leftWidth,
          duration: const Duration(milliseconds: 0),
          curve: Curves.fastOutSlowIn,
          child: left,
        ),
        const VerticalDivider(width: 1.0),
        Expanded(child: center),
      ],
    );
  }
}
