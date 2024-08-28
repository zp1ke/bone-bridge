import 'dart:async';
import 'dart:convert';

import 'package:chopper/chopper.dart';
import 'package:json_annotation/json_annotation.dart' as json_annot;

import '../../model/auth.dart';
import '../../model/user.dart';
import '../auth_service.dart';

part 'dummy_json_service.chopper.dart';
part 'dummy_json_service.g.dart';

// https://dummyjson.com/docs
class DummyJsonService implements AuthService {
  final _chopper = ChopperClient(
    baseUrl: Uri.https('dummyjson.com'),
    converter: const JsonConverter(),
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
      return _Auth.fromJson(response.body!);
    }

    // TODO: throw proper error
    throw response.error ?? response.statusCode;
  }

  @override
  Auth? parse(Map<String, dynamic> authMap) {
    return _Auth.fromJson(authMap);
  }
}

@ChopperApi(baseUrl: '/auth')
abstract class _ChopperAuthService extends ChopperService {
  static _ChopperAuthService create([ChopperClient? client]) =>
      _$_ChopperAuthService(client);

  @Post(path: '/login')
  Future<Response> login(@Body() Map<String, dynamic> body);
}

@json_annot.JsonSerializable()
class _User extends User {
  @override
  final int id;
  @override
  final String email;
  @override
  final String username;
  @override
  final String? firstName;
  @override
  final String? lastName;
  @override
  final String? image;

  _User({
    required this.id,
    required this.email,
    required this.username,
    this.firstName,
    this.lastName,
    this.image,
  });

  Map<String, dynamic> toJson() => _$UserToJson(this);

  @override
  String get asJson => jsonEncode(toJson());
}

@json_annot.JsonSerializable()
class _Auth extends _User implements Auth {
  @override
  final String token;
  @override
  final String refreshToken;

  _Auth({
    required super.id,
    required super.email,
    required super.username,
    super.firstName,
    super.lastName,
    super.image,
    required this.token,
    required this.refreshToken,
  });

  factory _Auth.fromJson(Map<String, dynamic> json) => _$AuthFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$AuthToJson(this);

  @override
  String get asJson => jsonEncode(toJson());
}
