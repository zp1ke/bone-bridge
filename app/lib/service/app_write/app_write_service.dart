import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';

import '../../common/logger.dart';
import '../../common/string.dart';
import '../../config.dart';
import '../../model/data_page.dart';
import '../../model/profile.dart';
import '../../model/todo.dart';
import '../../state/auth.dart';
import '../auth_service.dart';
import '../profile_service.dart';
import '../todo_service.dart';
import 'app_write_model.dart';

class AppWriteConfig {
  final String projectID;
  final String todosDbId;
  final String todosLotId;
  final String profilesDbId;
  final String profilesLotId;

  AppWriteConfig._({
    required this.projectID,
    required this.todosDbId,
    required this.todosLotId,
    required this.profilesDbId,
    required this.profilesLotId,
  });

  factory AppWriteConfig.create() => AppWriteConfig._(
        projectID: AppConfig.appwritProjectID,
        todosDbId: AppConfig.appwritTodosDbID,
        todosLotId: AppConfig.appwritTodosLotID,
        profilesDbId: AppConfig.appwritProfilesDbID,
        profilesLotId: AppConfig.appwritProfilesLotID,
      );

  bool get isValid => projectID.isNotEmpty;

  bool get canHandleTodos => todosDbId.isNotEmpty && todosLotId.isNotEmpty;

  bool get canHandleProfiles =>
      profilesDbId.isNotEmpty && profilesLotId.isNotEmpty;
}

const _userIdKey = 'user_id';

// https://appwrite.io/docs
class AppWriteService implements AuthService, TodoService, ProfileService {
  final Client _client;
  final AppWriteConfig config;

  AppWriteService(this.config) : _client = Client() {
    _client
        .setEndpoint('https://cloud.appwrite.io/v1')
        .setProject(config.projectID)
        // For self signed certificates, only use for development
        .setSelfSigned(status: true);
  }

  bool get canHandleTodos => config.canHandleTodos;

  bool get canHandleProfiles => config.canHandleProfiles;

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
    return _authOf(session, user);
  }

  @override
  Future<DataPage<Todo>> fetchTodos(
    Auth auth, {
    required int page,
    required int pageSize,
  }) async {
    final databases = Databases(_client);
    final documents = await databases.listDocuments(
      databaseId: config.todosDbId,
      collectionId: config.todosLotId,
      queries: [
        Query.limit(pageSize),
        Query.offset(page * pageSize),
        Query.orderDesc('\$createdAt'),
        Query.equal(_userIdKey, auth.id),
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
  Future<Auth?> setupAuth(Map<String, dynamic> authMap) async {
    Auth? auth;
    try {
      final account = Account(_client);
      final session =
          await account.getSession(sessionId: authMap['token'] ?? '');
      final user = await account.get();
      return _authOf(session, user);
    } catch (e) {
      logError(
        'Could not load session user',
        name: '/service/app_write/app_write_service',
        error: e,
      );
      await clear();
    }
    return Future.value(auth);
  }

  @override
  Future clear() async {
    try {
      final account = Account(_client);
      await account.deleteSessions();
    } catch (_) {}
    return Future.value(null);
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
    todoMap[_userIdKey] = auth.id;
    final permissions = <String>[
      Permission.read(Role.user(auth.id)),
      Permission.update(Role.user(auth.id)),
      Permission.delete(Role.user(auth.id)),
    ];
    if (todo.isNew) {
      document = await databases.createDocument(
        databaseId: config.todosDbId,
        collectionId: config.todosLotId,
        documentId: randomUID(),
        data: todoMap,
        permissions: permissions,
      );
    } else {
      document = await databases.updateDocument(
        databaseId: config.todosDbId,
        collectionId: config.todosLotId,
        documentId: todo.id,
        data: todoMap,
        permissions: permissions,
      );
    }
    return AppWriteTodo.fromDocument(document);
  }

  Auth _authOf(Session session, User user) {
    return AppWriteAuth(
      id: user.$id,
      email: user.email,
      username: user.name,
      firstName: user.name,
      token: session.$id,
      refreshToken: session.providerRefreshToken,
    );
  }

  @override
  Future<Profile?> fetchProfile(Auth auth) async {
    final databases = Databases(_client);
    final documents = await databases.listDocuments(
      databaseId: config.profilesDbId,
      collectionId: config.profilesLotId,
      queries: [
        Query.limit(1),
        Query.offset(0),
        Query.orderAsc('\$createdAt'),
        Query.equal(_userIdKey, auth.id),
      ],
    );
    if (documents.documents.isNotEmpty) {
      return AppWriteProfile.fromDocument(documents.documents.first);
    }
    return null;
  }

  @override
  Profile createProfile() {
    return AppWriteProfile(id: '', username: '', isPublic: false);
  }

  @override
  Future<Profile> saveProfile(Auth auth, Profile profile) async {
    if (profile is! AppWriteProfile) {
      throw UnimplementedError();
    }

    final databases = Databases(_client);
    Document document;
    final profileMap = profile.toJson();
    profileMap[_userIdKey] = auth.id;
    final permissions = <String>[
      Permission.read(Role.user(auth.id)),
      Permission.update(Role.user(auth.id)),
      Permission.delete(Role.user(auth.id)),
    ];
    if (profile.isNew) {
      document = await databases.createDocument(
        databaseId: config.profilesDbId,
        collectionId: config.profilesLotId,
        documentId: randomUID(),
        data: profileMap,
        permissions: permissions,
      );
    } else {
      document = await databases.updateDocument(
        databaseId: config.profilesDbId,
        collectionId: config.profilesLotId,
        documentId: profile.id,
        data: profileMap,
        permissions: permissions,
      );
    }
    return AppWriteProfile.fromDocument(document);
  }
}
