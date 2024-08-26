import 'package:annotations/annotations.dart';
import 'package:flutter/widgets.dart';

// iconCode from https://api.flutter.dev/flutter/material/Icons/abc_outlined-constant.html
@AppPageRoute(path: '/a', label: 'Page A', iconCode: '0xf05b1')
class PageA extends StatelessWidget {
  const PageA({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('PAGE A'),
    );
  }
}
