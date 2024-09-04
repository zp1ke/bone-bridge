import 'package:appwrite/appwrite.dart';

import '../../model/auth.dart';
import '../../model/data_page.dart';
import '../../model/todo.dart';
import '../auth_service.dart';
import '../todo_service.dart';
import 'app_write_model.dart';

// https://appwrite.io/docs
class AppWriteService implements AuthService, TodoService {
  final Client _client;
  final String todosDatabaseID;
  final String todosCollectionID;

  late Account _account;
  late Databases _databases;

  AppWriteService({
    required String projectID,
    required this.todosDatabaseID,
    required this.todosCollectionID,
  }) : _client = Client() {
    _client
        .setEndpoint('https://cloud.appwrite.io/v1')
        .setProject(projectID)
        // For self signed certificates, only use for development
        .setSelfSigned(status: true);
    _account = Account(_client);
    _databases = Databases(_client);
  }

  bool get canHandleTodos =>
      todosDatabaseID.isNotEmpty && todosCollectionID.isNotEmpty;

  @override
  Future<Auth> authenticate(Credentials credentials) async {
    if (credentials is! UsernamePasswordCredentials) {
      throw UnimplementedError();
    }

    final session = await _account.createEmailPasswordSession(
      email: credentials.username,
      password: credentials.password,
    );
    final user = await _account.get();
    return AppWriteAuth(
      id: session.userId,
      email: user.email,
      username: user.name,
      firstName: user.name,
      token: session.providerAccessToken,
      refreshToken: session.providerRefreshToken,
    );
  }

  @override
  Future<DataPage<Todo>> fetchTodos(
    Auth auth, {
    required int page,
    required int pageSize,
  }) async {
    final documents = await _databases.listDocuments(
      databaseId: todosDatabaseID,
      collectionId: todosCollectionID,
      queries: [
        Query.limit(pageSize),
        Query.offset(page * pageSize),
      ],
    );
    final list = documents.documents.map(AppWriteTodo.fromDocument).toList();
    return DataPage(
      list: list,
      page: page,
      pageSize: pageSize,
      totalCount: documents.total,
    );
  }

  @override
  Auth? parse(Map<String, dynamic> authMap) {
    return AppWriteAuth.fromJson(authMap);
  }

  @override
  Future clear() {
    return _account.deleteSessions();
  }
}
