import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../common/logger.dart';
import '../service/todo_service.dart';
import 'auth.dart';
import 'data_page.dart';

abstract class Todo {
  int get id;

  String get description;

  bool get isCompleted;
}

class TodoState extends ChangeNotifier {
  final TodoService _todoService;

  DataPage<Todo> _todos;
  bool _fetching = false;

  static TodoState of(BuildContext context, {bool listen = false}) {
    return Provider.of<TodoState>(context, listen: listen);
  }

  DataPage<Todo>? get todos {
    if (_todos.page >= 0) {
      return _todos;
    }
    return null;
  }

  bool get fetching => _fetching;

  TodoState({
    required TodoService todoService,
  })  : _todoService = todoService,
        _todos = DataPage.empty();

  Future fetchTodos(
    Auth auth, {
    required int page,
    required int pageSize,
    bool force = false,
  }) async {
    if (!_fetching && (force || page != _todos.page)) {
      logDebug('Fetching TODOs page $page', name: 'model/todo');

      _fetching = true;
      notifyListeners();

      _todos = await _todoService.fetchTodos(
        auth,
        page: page,
        pageSize: pageSize,
      );
      _fetching = false;
      notifyListeners();
    }
  }

  Future clear() async {
    _todos = DataPage.empty();
    _fetching = false;
    notifyListeners();
  }
}
