import 'package:annotations/annotations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/auth.dart';
import '../../model/todo.dart';
import '../shell/page_state.dart';
import '../widget/paginated_list.dart';

@AppPageRoute(path: '/todos', label: 'todos', iconCode: 'todos')
class TodosPage extends StatefulWidget {
  const TodosPage({super.key});

  @override
  State<TodosPage> createState() => _TodosPageState();
}

class _TodosPageState extends PageState<TodosPage> {
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

  void fetchPage({bool force = false}) {
    TodoState.of(context).fetchTodos(
      auth,
      page: page,
      pageSize: pageSize,
      force: force,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TodoState>(
      builder: (context, todoState, child) {
        if (todoState.todos != null) {
          // return body(todoState.todos!, todoState.fetching);
          return PaginatedListWidget<Todo>(
            dataPage: todoState.todos!,
            fetching: todoState.fetching,
            itemBuilder: itemWidget,
            onPageChanged: (value) {
              setState(() {
                page = value;
              });
              fetchPage();
            },
          );
        }
        return child!;
      },
      child: const Center(
        child: CircularProgressIndicator.adaptive(),
      ),
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
      trailing: Checkbox(
        value: todo.isCompleted,
        onChanged: (_) {},
      ),
    );
  }

  @override
  bool get canAdd => true;

  @override
  bool get canReload => true;

  @override
  void onAdd() {
    // TODO: implement onAdd
  }

  @override
  void onReload() {
    fetchPage(force: true);
  }
}
