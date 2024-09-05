import 'dart:convert';

import 'package:appwrite/models.dart' as models;
import 'package:json_annotation/json_annotation.dart';

import '../../state/auth.dart';
import '../../model/todo.dart';
import '../../model/user.dart';

part 'app_write_model.g.dart';

@JsonSerializable()
class AppWriteUser extends User {
  @override
  final String id;

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

  AppWriteUser({
    required this.id,
    required this.email,
    required this.username,
    this.firstName,
    this.lastName,
    this.image,
  });

  Map<String, dynamic> toJson() => _$AppWriteUserToJson(this);

  @override
  String get asJson => jsonEncode(toJson());
}

@JsonSerializable()
class AppWriteAuth extends AppWriteUser implements Auth {
  @override
  final String token;
  @override
  final String refreshToken;

  AppWriteAuth({
    required super.id,
    required super.email,
    required super.username,
    super.firstName,
    super.lastName,
    super.image,
    required this.token,
    required this.refreshToken,
  });

  factory AppWriteAuth.fromJson(Map<String, dynamic> json) =>
      _$AppWriteAuthFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$AppWriteAuthToJson(this);

  @override
  String get asJson => jsonEncode(toJson());
}

@JsonSerializable()
class AppWriteTodo extends Todo {
  @override
  final String id;

  @override
  bool get isNew => id.isEmpty;

  @override
  String description;

  @JsonKey(name: 'completed')
  @override
  bool isCompleted;

  AppWriteTodo({
    required this.id,
    required this.description,
    this.isCompleted = false,
  });

  factory AppWriteTodo.fromJson(Map<String, dynamic> json) =>
      _$AppWriteTodoFromJson(json);

  factory AppWriteTodo.fromDocument(models.Document document) {
    final map = document.data;
    map['id'] = document.$id;
    return AppWriteTodo.fromJson(map);
  }

  Map<String, dynamic> toJson() => _$AppWriteTodoToJson(this);
}
