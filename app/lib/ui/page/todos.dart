import 'package:annotations/annotations.dart';
import 'package:flutter/widgets.dart';

@AppPageRoute(path: '/todos', label: 'todos', iconCode: 'todos')
class TodosPage extends StatelessWidget {
  const TodosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('TODO'),
    );
  }
}
