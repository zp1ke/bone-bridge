import 'package:annotations/annotations.dart';
import 'package:flutter/material.dart';

import '../../../app/router.dart';
import '../../../common/locator.dart';
import '../../../model/data_page.dart';
import '../../../model/todo.dart';
import '../../../service/todo_service.dart';
import '../../../state/auth.dart';
import '../../shell/page_state.dart';
import '../../widget/crud_page.dart';
import 'todos_edit.dart';

@AppPageRoute(path: '/todos', label: 'todos', iconCode: 'todos')
class TodosPage extends StatefulWidget {
  const TodosPage({super.key});

  @override
  State<TodosPage> createState() => _TodosPageState();
}

class _TodosPageState extends PageState<TodosPage> {
  final crudKey = GlobalKey<CrudState<Todo>>();

  @override
  Widget build(BuildContext context) {
    return CrudPage<Todo>(
      key: crudKey,
      routeConfigurer: () => RouteConfig(canAddData: true, canReloadData: true),
      dataFetcher: fetchPage,
      listItemBuilder: listItemWidget,
      editItemBuilder: editItemWidget,
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

  Widget listItemWidget(BuildContext context, Todo todo, bool fetching) {
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
      onTap: () {
        editTodo(todo);
      },
    );
  }

  Widget editItemWidget(BuildContext context, Todo? item) {
    final todo = item ?? getService<TodoService>().createTodo();
    return Container(
      height: 260,
      alignment: Alignment.center,
      child: TodosEditWidget(
        todo: todo,
        onDone: save,
      ),
    );
  }

  @override
  void onAdd() {
    editTodo();
  }

  @override
  void onReload() {
    crudKey.currentState?.fetchPage(force: true);
  }

  void editTodo([Todo? value]) async {
    final todo = await crudKey.currentState?.editItem(value);
    debugPrint('TODO edited = ${todo?.id} - ${todo?.description}');
  }

  Future save(Todo todo) async {
    final auth = AuthState.of(context).auth!;
    await getService<TodoService>().saveTodo(auth, todo);
    if (mounted) {
      context.pop(todo);
      crudKey.currentState?.fetchPage(reset: true);
    }
    return Future.value(null);
  }
}
