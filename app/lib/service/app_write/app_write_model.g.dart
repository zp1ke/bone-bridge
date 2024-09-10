// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_write_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppWriteUser _$AppWriteUserFromJson(Map<String, dynamic> json) => AppWriteUser(
      id: json['id'] as String,
      email: json['email'] as String,
      username: json['username'] as String,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      image: json['image'] as String?,
    );

Map<String, dynamic> _$AppWriteUserToJson(AppWriteUser instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'username': instance.username,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'image': instance.image,
    };

AppWriteAuth _$AppWriteAuthFromJson(Map<String, dynamic> json) => AppWriteAuth(
      id: json['id'] as String,
      email: json['email'] as String,
      username: json['username'] as String,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      image: json['image'] as String?,
      token: json['token'] as String,
      refreshToken: json['refreshToken'] as String,
    );

Map<String, dynamic> _$AppWriteAuthToJson(AppWriteAuth instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'username': instance.username,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'image': instance.image,
      'token': instance.token,
      'refreshToken': instance.refreshToken,
    };

AppWriteTodo _$AppWriteTodoFromJson(Map<String, dynamic> json) => AppWriteTodo(
      id: json['id'] as String,
      description: json['description'] as String,
      isCompleted: json['completed'] as bool? ?? false,
    );

Map<String, dynamic> _$AppWriteTodoToJson(AppWriteTodo instance) =>
    <String, dynamic>{
      'description': instance.description,
      'completed': instance.isCompleted,
    };

AppWriteProfile _$AppWriteProfileFromJson(Map<String, dynamic> json) =>
    AppWriteProfile(
      id: json['id'] as String,
      username: json['username'] as String,
      isPublic: json['is_public'] as bool,
      name: json['name'] as String? ?? '',
      summary: json['summary'] as String? ?? '',
    );

Map<String, dynamic> _$AppWriteProfileToJson(AppWriteProfile instance) =>
    <String, dynamic>{
      'username': instance.username,
      'is_public': instance.isPublic,
      'name': instance.name,
      'summary': instance.summary,
    };
