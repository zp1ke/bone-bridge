import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';

import '../../common/string.dart';
import '../../model/data_page.dart';
import '../../model/todo.dart';
import '../../state/auth.dart';
import '../auth_service.dart';
import '../todo_service.dart';
import 'app_write_model.dart';

// https://appwrite.io/docs
class AppWriteService implements AuthService, TodoService {
  final Client _client;
  final String todosDatabaseID;
  final String todosCollectionID;

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
  }

  bool get canHandleTodos =>
      todosDatabaseID.isNotEmpty && todosCollectionID.isNotEmpty;

  @override
  Future<Auth> authenticate(Credentials credentials) async {
    if (credentials is! UsernamePasswordCredentials) {
      throw UnimplementedError();
    }

    final account = Account(_client);
    final session = await account.createEmailPasswordSession(
      email: credentials.username,
      password: credentials.password,
    );
    final user = await account.get();
    return AppWriteAuth(
      id: user.$id,
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
    final databases = Databases(_client);
    final documents = await databases.listDocuments(
      databaseId: todosDatabaseID,
      collectionId: todosCollectionID,
      queries: [
        Query.limit(pageSize),
        Query.offset(page * pageSize),
        Query.orderDesc('\$createdAt'),
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
  Future<Auth?> setupAuth(Map<String, dynamic> authMap) {
    final auth = AppWriteAuth.fromJson(authMap);
    return Future.value(auth);
  }

  @override
  Future clear() {
    final account = Account(_client);
    return account.deleteSessions();
  }

  @override
  Todo createTodo() {
    return AppWriteTodo(id: '', description: '');
  }

  @override
  Future<Todo> saveTodo(Auth auth, Todo todo) async {
    if (todo is! AppWriteTodo) {
      throw UnimplementedError();
    }

    final databases = Databases(_client);
    Document document;
    final todoMap = todo.toJson();
    final permissions = <String>[
      Permission.read(Role.user(auth.id)),
      Permission.update(Role.user(auth.id)),
      Permission.delete(Role.user(auth.id)),
    ];
    if (todo.isNew) {
      document = await databases.createDocument(
        databaseId: todosDatabaseID,
        collectionId: todosCollectionID,
        documentId: randomUID(),
        data: todoMap,
        permissions: permissions,
      );
    } else {
      document = await databases.updateDocument(
        databaseId: todosDatabaseID,
        collectionId: todosCollectionID,
        documentId: todo.id,
        data: todoMap,
        permissions: permissions,
      );
    }
    return AppWriteTodo.fromDocument(document);
  }
}
