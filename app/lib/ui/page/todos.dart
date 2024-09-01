import 'package:annotations/annotations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/auth.dart';
import '../../model/data_page.dart';
import '../../model/todo.dart';
import '../shell/page_state.dart';
import '../widget/paginated_list.dart';
import '../widget/responsive.dart';

@AppPageRoute(path: '/todos', label: 'todos', iconCode: 'todos')
class TodosPage extends StatefulWidget {
  const TodosPage({super.key});

  @override
  State<TodosPage> createState() => _TodosPageState();
}

class _TodosPageState extends PageState<TodosPage> {
  final scrollController = ScrollController();

  late Auth auth;
  var scrollPaginated = false;
  var dataPage = DataPage<Todo>.empty();
  var fetching = false;

  var page = 0;
  var pageSize = 15; // TODO: config
  var lastPage = 10000;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      setState(() {
        auth = AuthState.of(context).auth!;
      });
      fetchPage();
      scrollController.addListener(() async {
        final scrollPosition = scrollController.position;
        if (scrollPaginated &&
            scrollPosition.pixels == scrollPosition.maxScrollExtent &&
            page < lastPage) {
          setState(() {
            page += 1;
          });
          fetchPage();
        }
      });
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
          lastPage = todoState.todos!.totalCount ~/ pageSize;
          if (scrollPaginated) {
            dataPage.add(todoState.todos!);
          } else {
            dataPage = todoState.todos!;
          }
          fetching = todoState.fetching;
          return ResponsiveWidget(
            small: (context) {
              scrollPaginated = true;
              return body();
            },
            medium: (context) {
              scrollPaginated = false;
              return body();
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

  Widget body() {
    return PaginatedListWidget<Todo>(
      dataPage: dataPage,
      fetching: fetching,
      itemBuilder: itemWidget,
      scrollController: scrollController,
      onPageChanged: (value) {
        setState(() {
          page = value;
        });
        fetchPage();
      },
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
        onChanged: !fetching ? (_) {} : null,
      ),
    );
  }

  @override
  bool get canAdd => !fetching;

  @override
  bool get canReload => !fetching;

  @override
  void onAdd() {
    // TODO: implement onAdd
  }

  @override
  void onReload() {
    setState(() {
      page = 0;
    });
    fetchPage(force: true);
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}
