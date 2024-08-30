import 'package:annotations/annotations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/auth.dart';
import '../../model/data_page.dart';
import '../../model/todo.dart';

@AppPageRoute(path: '/todos', label: 'todos', iconCode: 'todos')
class TodosPage extends StatefulWidget {
  const TodosPage({super.key});

  @override
  State<TodosPage> createState() => _TodosPageState();
}

class _TodosPageState extends State<TodosPage> {
  late Auth auth;

  int page = 0;
  int pageSize = 10; // TODO: config

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      setState(() {
        auth = AuthState.of(context).auth!;
      });
      fetchPage();
    });
  }

  void fetchPage() {
    TodoState.of(context).fetchTodos(auth, page: page, pageSize: pageSize);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TodoState>(
      builder: (context, todoState, child) {
        if (todoState.todos != null) {
          return listView(todoState.todos!);
        }
        return child!;
      },
      child: const Center(
        child: CircularProgressIndicator.adaptive(),
      ),
    );
  }

  Widget listView(DataPage<Todo> todos) {
    if (todos.list.isEmpty) {
      return const Center(
        child: Text('Nothing here :( TODO L10N'),
      );
    }

    final list = todos.list.toList();
    return ListView.separated(
      itemBuilder: (context, index) {
        final todo = list[index];
        return itemWidget(todo);
      },
      separatorBuilder: (context, index) {
        return const Divider();
      },
      itemCount: list.length,
    );
  }

  Widget itemWidget(Todo todo) {
    return ListTile(
      title: Text(
        todo.description,
        style: TextStyle(
          fontStyle: todo.isCompleted ? FontStyle.italic : null,
          color: todo.isCompleted ? Theme.of(context).disabledColor : null,
        ),
      ),
      trailing: Switch(
        value: todo.isCompleted,
        onChanged: null,
      ),
    );
  }
}
