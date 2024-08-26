import 'package:flutter/material.dart';

import '../../app/router.dart';
import '../component/responsive.dart';

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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 10.0),
          child: Text('HOME PAGE LARGE!'),
        ),
        TextButton(
            onPressed: () {
              context.navTo('/a');
            },
            child: const Text('GO A')),
      ],
    );
  }
}
