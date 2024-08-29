import '../model/data_page.dart';
import '../model/todo.dart';

abstract class TodoService {
  Future<DataPage<Todo>> fetchTodos({
    required int page,
    required int pageSize,
  });
}
