import 'package:annotations/annotations.dart';
import 'package:flutter/material.dart';

import '../../common/locator.dart';
import '../../model/auth.dart';
import '../../model/data_page.dart';
import '../../model/todo.dart';
import '../../service/todo_service.dart';
import '../shell/page_state.dart';
import '../widget/crud_page.dart';

@AppPageRoute(path: '/todos', label: 'todos', iconCode: 'todos')
class TodosPage extends StatefulWidget {
  const TodosPage({super.key});

  @override
  State<TodosPage> createState() => _TodosPageState();
}

class _TodosPageState extends PageState<TodosPage> {
  final crudKey = GlobalKey<CrudState>();

  @override
  Widget build(BuildContext context) {
    return CrudPage<Todo>(
      key: crudKey,
      routeConfigurer: () => RouteConfig(canAddData: true, canReloadData: true),
      dataFetcher: fetchPage,
      itemBuilder: itemWidget,
    );
  }

  Future<DataPage<Todo>> fetchPage({required int page, required int pageSize}) {
    final auth = AuthState.of(context).auth!;
    final todoService = getService<TodoService>();
    return todoService.fetchTodos(
      auth,
      page: page,
      pageSize: pageSize,
    );
  }

  Widget itemWidget(Todo todo, bool fetching) {
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
        onChanged: !fetching ? (_) {} : null,
      ),
    );
  }

  @override
  void onAdd() {
    // TODO: implement onAdd
  }

  @override
  void onReload() {
    crudKey.currentState?.fetchPage(force: true);
  }
}
