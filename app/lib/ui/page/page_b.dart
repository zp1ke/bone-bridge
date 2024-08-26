import 'package:annotations/annotations.dart';
import 'package:flutter/widgets.dart';

@AppPageRoute(path: '/b', label: 'Page B', iconCode: '0xe73b')
class PageB extends StatelessWidget {
  const PageB({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('PAGE B'),
    );
  }
}
