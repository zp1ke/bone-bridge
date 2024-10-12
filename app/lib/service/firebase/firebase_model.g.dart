// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'firebase_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FirebaseAppUser _$FirebaseAppUserFromJson(Map<String, dynamic> json) =>
    FirebaseAppUser(
      id: json['id'] as String,
      email: json['email'] as String,
      username: json['username'] as String,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      image: json['image'] as String?,
    );

Map<String, dynamic> _$FirebaseAppUserToJson(FirebaseAppUser instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'username': instance.username,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'image': instance.image,
    };

FirebaseAppAuth _$FirebaseAppAuthFromJson(Map<String, dynamic> json) =>
    FirebaseAppAuth(
      id: json['id'] as String,
      email: json['email'] as String,
      username: json['username'] as String,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      image: json['image'] as String?,
      token: json['token'] as String,
      refreshToken: json['refreshToken'] as String,
    );

Map<String, dynamic> _$FirebaseAppAuthToJson(FirebaseAppAuth instance) =>
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

FirebaseAppTodo _$FirebaseAppTodoFromJson(Map<String, dynamic> json) =>
    FirebaseAppTodo(
      id: json['id'] as String,
      description: json['description'] as String,
      isCompleted: json['completed'] as bool? ?? false,
    );

Map<String, dynamic> _$FirebaseAppTodoToJson(FirebaseAppTodo instance) =>
    <String, dynamic>{
      'description': instance.description,
      'completed': instance.isCompleted,
    };

FirebaseAppProfile _$FirebaseAppProfileFromJson(Map<String, dynamic> json) =>
    FirebaseAppProfile(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      username: json['username'] as String,
      isPublic: json['is_public'] as bool,
      name: json['name'] as String? ?? '',
      summary: json['summary'] as String? ?? '',
      links: (json['links'] as List<dynamic>)
          .map((e) => FirebaseProfileLink.fromJson(e as Map<String, dynamic>))
          .toSet(),
    );

Map<String, dynamic> _$FirebaseAppProfileToJson(FirebaseAppProfile instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'username': instance.username,
      'is_public': instance.isPublic,
      'name': instance.name,
      'summary': instance.summary,
      'links': instance.links.toList(),
    };

FirebaseProfileLink _$FirebaseProfileLinkFromJson(Map<String, dynamic> json) =>
    FirebaseProfileLink(
      link: json['link'] as String,
      iconData: const IconDataConverter().fromJson(json['iconData'] as String),
    );

Map<String, dynamic> _$FirebaseProfileLinkToJson(
        FirebaseProfileLink instance) =>
    <String, dynamic>{
      'link': instance.link,
      'iconData': const IconDataConverter().toJson(instance.iconData),
    };
