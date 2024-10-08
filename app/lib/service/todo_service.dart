import '../model/data_page.dart';
import '../model/todo.dart';
import '../state/auth.dart';

abstract class TodoService {
  Future<DataPage<Todo>> fetchTodos(
    Auth auth, {
    required int page,
    required int pageSize,
  });

  Todo createTodo();

  Future<Todo> saveTodo(Auth auth, Todo todo);
}
