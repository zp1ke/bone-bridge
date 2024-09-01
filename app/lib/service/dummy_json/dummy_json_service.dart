import 'dart:async';
import 'dart:convert';

import 'package:chopper/chopper.dart';

import '../../model/auth.dart';
import '../../model/data_page.dart';
import '../../model/todo.dart';
import '../auth_service.dart';
import '../todo_service.dart';
import 'dummy_json_model.dart';

part 'dummy_json_service.chopper.dart';

// https://dummyjson.com/docs
class DummyJsonService implements AuthService, TodoService {
  final _chopper = ChopperClient(
    baseUrl: Uri.https('dummyjson.com'),
    converter: const JsonConverter(),
    services: [_ChopperService.create()],
  );

  @override
  Future<Auth> authenticate(Credentials credentials) async {
    if (credentials is! UsernamePasswordCredentials) {
      throw UnimplementedError();
    }

    final service = _chopper.getService<_ChopperService>();
    final response = await service.login({
      'username': credentials.username,
      'password': credentials.password,
    });
    if (response.isSuccessful) {
      return DummyJsonAuth.fromJson(response.body!);
    }
    throw _error(response);
  }

  @override
  Auth? parse(Map<String, dynamic> authMap) {
    return DummyJsonAuth.fromJson(authMap);
  }

  @override
  Future<DataPage<Todo>> fetchTodos(
    Auth auth, {
    required int page,
    required int pageSize,
  }) async {
    final service = _chopper.getService<_ChopperService>();
    final skip = page * pageSize;

    /// Intentional delay
    await Future.delayed(const Duration(milliseconds: 100));
    final response = await service.fetchTodos(pageSize, skip);
    if (response.isSuccessful) {
      return _parseDataPage<Todo>(
        response.body!,
        listKey: 'todos',
        typeParser: (map) {
          return DummyJsonTodo.fromJson(map);
        },
      );
    }
    throw _error(response);
  }

  DataPage<T> _parseDataPage<T>(
    Map<String, dynamic> json, {
    required String listKey,
    required _TypeParser<T> typeParser,
  }) {
    final List list = json[listKey] ?? [];
    final limit = (json['limit'] as num?) ?? 0;
    final skip = (json['skip'] as num?) ?? 0;
    final page = limit > 0 ? skip / limit : 0;
    return DataPage<T>(
      list: list.whereType<Map<String, dynamic>>().map((item) {
        return typeParser(item);
      }).toList(),
      page: page.toInt(),
      pageSize: limit.toInt(),
      totalCount: json['total'] ?? list.length,
    );
  }

  Object _error(Response response) {
    String? errorMessage;
    if (response.error is String) {
      errorMessage = jsonDecode(response.error as String)['message'];
    }
    return DummyJsonHttpError(
        statusCode: response.statusCode, message: errorMessage);
  }
}

typedef _TypeParser<T> = T Function(Map<String, dynamic>);

@ChopperApi()
abstract class _ChopperService extends ChopperService {
  static _ChopperService create([ChopperClient? client]) =>
      _$_ChopperService(client);

  @Post(path: '/auth/login')
  Future<Response> login(@Body() Map<String, dynamic> body);

  @Get(path: '/todos')
  Future<Response> fetchTodos(@Query() int limit, @Query() int skip);
}
