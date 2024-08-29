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
    final response = await service.fetchTodos(
      auth.id.toString(),
      pageSize,
      skip,
    );
    if (response.isSuccessful) {
      /*
      {
        "todos": [
          {
            "id": 19,
            "todo": "Create a compost pile",
            "completed": true,
            "userId": 5 // user id is 5
          },
          {...},
          {...}
        ],
        "total": 3,
        "skip": 0,
        "limit": 3
      }
       */
    }
    throw _error(response);
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

@ChopperApi()
abstract class _ChopperService extends ChopperService {
  static _ChopperService create([ChopperClient? client]) =>
      _$_ChopperService(client);

  @Post(path: '/auth/login')
  Future<Response> login(@Body() Map<String, dynamic> body);

  @Get(path: '/todos/user/{userId}')
  Future<Response> fetchTodos(
    @Path() String userId,
    @Query() int limit,
    @Query() int skip,
  );
}
