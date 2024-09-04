import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

import '../../model/auth.dart';
import '../../model/http_error.dart';
import '../../model/todo.dart';
import '../../model/user.dart';

part 'dummy_json_model.g.dart';

@JsonSerializable()
class DummyJsonUser extends User {
  @override
  String get id => userId.toString();

  @JsonKey(name: 'id')
  final int userId;

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

  DummyJsonUser({
    required this.userId,
    required this.email,
    required this.username,
    this.firstName,
    this.lastName,
    this.image,
  });

  Map<String, dynamic> toJson() => _$DummyJsonUserToJson(this);

  @override
  String get asJson => jsonEncode(toJson());
}

@JsonSerializable()
class DummyJsonAuth extends DummyJsonUser implements Auth {
  @override
  final String token;
  @override
  final String refreshToken;

  DummyJsonAuth({
    required super.userId,
    required super.email,
    required super.username,
    super.firstName,
    super.lastName,
    super.image,
    required this.token,
    required this.refreshToken,
  });

  factory DummyJsonAuth.fromJson(Map<String, dynamic> json) =>
      _$DummyJsonAuthFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$DummyJsonAuthToJson(this);

  @override
  String get asJson => jsonEncode(toJson());
}

@JsonSerializable()
class DummyJsonTodo extends Todo {
  @override
  String get id => todoId.toString();

  @JsonKey(name: 'id')
  final int todoId;

  @JsonKey(name: 'todo')
  @override
  final String description;

  @JsonKey(name: 'completed')
  @override
  final bool isCompleted;

  DummyJsonTodo({
    required this.todoId,
    required this.description,
    this.isCompleted = false,
  });

  factory DummyJsonTodo.fromJson(Map<String, dynamic> json) =>
      _$DummyJsonTodoFromJson(json);

  Map<String, dynamic> toJson() => _$DummyJsonTodoToJson(this);
}

class DummyJsonHttpError extends HttpError {
  @override
  final int statusCode;
  @override
  final String? message;

  DummyJsonHttpError({
    required this.statusCode,
    required this.message,
  });
}
