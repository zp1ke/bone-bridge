import 'dart:async';

import 'package:chopper/chopper.dart';

import '../../model/auth.dart';
import '../auth_service.dart';

part 'dummy_json_service.chopper.dart';

// https://dummyjson.com/docs
class DummyJsonService implements AuthService {
  final _chopper = ChopperClient(
    baseUrl: Uri.https('dummyjson.com'),
    services: [_ChopperAuthService.create()],
  );

  @override
  Future<Auth> authenticate(Credentials credentials) async {
    if (credentials is! UsernamePasswordCredentials) {
      // TODO: throw proper error
      throw UnimplementedError();
    }

    final authService = _chopper.getService<_ChopperAuthService>();
    final response = await authService.login({
      'username': credentials.username,
      'password': credentials.password,
    });
    if (response.isSuccessful) {
      return response.body!;
    }

    // TODO: throw proper error
    throw {
      'code': response.statusCode,
      'message': response.error,
    };
  }
}

@ChopperApi(baseUrl: '/auth')
abstract class _ChopperAuthService extends ChopperService {
  static _ChopperAuthService create([ChopperClient? client]) =>
      _$_ChopperAuthService(client);

  @Post(path: '/login')
  Future<Response<Auth>> login(@Body() Map<String, dynamic> body);
}
