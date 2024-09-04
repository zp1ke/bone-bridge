// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dummy_json_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DummyJsonUser _$DummyJsonUserFromJson(Map<String, dynamic> json) =>
    DummyJsonUser(
      userId: (json['id'] as num).toInt(),
      email: json['email'] as String,
      username: json['username'] as String,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      image: json['image'] as String?,
    );

Map<String, dynamic> _$DummyJsonUserToJson(DummyJsonUser instance) =>
    <String, dynamic>{
      'id': instance.userId,
      'email': instance.email,
      'username': instance.username,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'image': instance.image,
    };

DummyJsonAuth _$DummyJsonAuthFromJson(Map<String, dynamic> json) =>
    DummyJsonAuth(
      userId: (json['id'] as num).toInt(),
      email: json['email'] as String,
      username: json['username'] as String,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      image: json['image'] as String?,
      token: json['token'] as String,
      refreshToken: json['refreshToken'] as String,
    );

Map<String, dynamic> _$DummyJsonAuthToJson(DummyJsonAuth instance) =>
    <String, dynamic>{
      'id': instance.userId,
      'email': instance.email,
      'username': instance.username,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'image': instance.image,
      'token': instance.token,
      'refreshToken': instance.refreshToken,
    };

DummyJsonTodo _$DummyJsonTodoFromJson(Map<String, dynamic> json) =>
    DummyJsonTodo(
      todoId: (json['id'] as num).toInt(),
      description: json['todo'] as String,
      isCompleted: json['completed'] as bool? ?? false,
    );

Map<String, dynamic> _$DummyJsonTodoToJson(DummyJsonTodo instance) =>
    <String, dynamic>{
      'id': instance.todoId,
      'todo': instance.description,
      'completed': instance.isCompleted,
    };
