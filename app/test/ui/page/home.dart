import 'package:app/ui/component/responsive.dart';
import 'package:flutter/material.dart';

class HomeTestPage extends StatelessWidget {
  static const smallText = 'HOME PAGE SMALL';
  static const mediumText = 'HOME PAGE MEDIUM';
  static const largeText = 'HOME PAGE LARGE';

  const HomeTestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
      small: _small,
      medium: _medium,
      large: _large,
    );
  }

  Widget _small(BuildContext context) {
    return const Center(child: Text(smallText));
  }

  Widget _medium(BuildContext context) {
    return const Center(child: Text(mediumText));
  }

  Widget _large(BuildContext context) {
    return const Center(child: Text(largeText));
  }
}
