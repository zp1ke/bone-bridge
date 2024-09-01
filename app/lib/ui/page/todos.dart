import 'package:annotations/annotations.dart';
import 'package:flutter/material.dart';

import '../../common/locator.dart';
import '../../model/auth.dart';
import '../../model/data_page.dart';
import '../../model/todo.dart';
import '../../service/todo_service.dart';
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
  var pageSize = 10; // TODO: config
  var lastPage = 10000;

  TodoService get todoService => getService<TodoService>();

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

  void fetchPage({bool force = false}) async {
    if (!fetching && (force || page != dataPage.page)) {
      setState(() {
        fetching = true;
      });
      final data = await todoService.fetchTodos(
        auth,
        page: page,
        pageSize: pageSize,
      );
      if (scrollPaginated) {
        dataPage.add(data);
      } else {
        dataPage = data;
      }
      setState(() {
        lastPage = dataPage.totalCount ~/ pageSize;
        fetching = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (dataPage.page < 0) {
      return const Center(
        child: CircularProgressIndicator.adaptive(),
      );
    }

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
    fetchPage(force: true);
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}
