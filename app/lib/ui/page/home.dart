import 'package:flutter/material.dart';

import '../widget/responsive.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
      small: _small,
      medium: _medium,
      large: _large,
    );
  }

  Widget _small(BuildContext context) {
    return const Center(child: Text('HOME PAGE SMALL!'));
  }

  Widget _medium(BuildContext context) {
    return const Center(child: Text('HOME PAGE MEDIUM!'));
  }

  Widget _large(BuildContext context) {
    return const Center(child: Text('HOME PAGE LARGE!'));
  }
}
