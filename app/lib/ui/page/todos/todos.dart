import 'package:annotations/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

import '../../../app/router.dart';
import '../../../common/locator.dart';
import '../../../config.dart';
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
      itemLabel: L10n.of(context).todos,
      pageSize: AppConfig.defaultPaginationSize,
      pageSizes: AppConfig.paginationSizes,
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
        onChanged: !fetching
            ? (value) {
                if (value != null) {
                  todo.isCompleted = value;
                  save(todo, popOnDone: false);
                }
              }
            : null,
      ),
      onTap: () {
        editTodo(todo);
      },
    );
  }

  Widget editItemWidget(BuildContext context, Todo? item) {
    final todo = item ?? getService<TodoService>().createTodo();
    return Container(
      alignment: Alignment.center,
      child: TodosEditWidget(
        todo: todo,
        onDone: (todo) => save(todo, popOnDone: true),
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
    await crudKey.currentState?.editItem(value);
  }

  Future save(Todo todo, {required bool popOnDone}) async {
    final auth = AuthState.of(context).auth!;
    await getService<TodoService>().saveTodo(auth, todo);
    if (mounted) {
      if (popOnDone) {
        context.pop(todo);
      }
      crudKey.currentState?.fetchPage(force: true, reset: todo.isNew);
    }
    return Future.value(null);
  }
}
