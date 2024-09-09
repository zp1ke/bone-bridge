import 'dart:convert';

import 'package:appwrite/models.dart' as models;
import 'package:json_annotation/json_annotation.dart';

import '../../model/profile.dart';
import '../../model/todo.dart';
import '../../model/user.dart';
import '../../state/auth.dart';

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
  @JsonKey(includeToJson: false)
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

@JsonSerializable()
class AppWriteProfile extends Profile {
  static const usernameKey = 'username';
  static const isPublicKey = 'is_public';

  @JsonKey(includeToJson: false)
  @override
  final String id;

  @override
  bool get isNew => id.isEmpty;

  @override
  String username;

  @JsonKey(name: isPublicKey)
  @override
  bool isPublic;

  AppWriteProfile({
    required this.id,
    required this.username,
    required this.isPublic,
  });

  factory AppWriteProfile.fromJson(Map<String, dynamic> json) =>
      _$AppWriteProfileFromJson(json);

  factory AppWriteProfile.fromDocument(models.Document document) {
    final map = document.data;
    map['id'] = document.$id;
    return AppWriteProfile.fromJson(map);
  }

  Map<String, dynamic> toJson() => _$AppWriteProfileToJson(this);

  @override
  String get asJson => jsonEncode(toJson());
}
