import 'dart:convert';

import 'package:appwrite/models.dart' as models;
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../common/string.dart';
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

  @JsonKey(name: 'user_id')
  @override
  String userId;

  @override
  bool get isNew => id.isEmpty;

  @override
  String username;

  @JsonKey(name: isPublicKey)
  @override
  bool isPublic;

  @override
  String name;

  @override
  String summary;

  @override
  final Set<AppWriteProfileLink> links;

  AppWriteProfile({
    required this.id,
    required this.userId,
    required this.username,
    required this.isPublic,
    this.name = '',
    this.summary = '',
    required this.links,
  });

  factory AppWriteProfile.fromJson(Map<String, dynamic> json) {
    final map = Map.of(json);
    var linksKey = 'links';
    if (map[linksKey] is List) {
      map[linksKey] =
          (json[linksKey] as List).map((item) => jsonDecode(item)).toList();
    }
    return _$AppWriteProfileFromJson(map);
  }

  factory AppWriteProfile.fromDocument(models.Document document) {
    final map = document.data;
    map['id'] = document.$id;
    return AppWriteProfile.fromJson(map);
  }

  Map<String, dynamic> toJson() {
    final map = _$AppWriteProfileToJson(this);
    map['links'] =
        links.map((link) => jsonEncode(link.toJson())).toList(growable: false);
    return map;
  }

  @override
  String get asJson => jsonEncode(toJson());

  @override
  Profile copyWith({
    String? username,
    bool? isPublic,
    String? name,
    String? summary,
    Set<ProfileLink>? links,
  }) =>
      AppWriteProfile(
        id: id,
        userId: userId,
        username: username ?? this.username,
        isPublic: isPublic ?? this.isPublic,
        name: name ?? this.name,
        summary: summary ?? this.summary,
        links: links?.map((link) => link as AppWriteProfileLink).toSet() ??
            this.links,
      );

  @override
  void addLink(ProfileLink link) {
    if (link is! AppWriteProfileLink) {
      throw UnimplementedError();
    }
  }
}

@JsonSerializable()
class AppWriteProfileLink extends ProfileLink {
  @JsonKey(includeToJson: false, includeFromJson: false)
  @override
  final String id;

  @override
  final String link;

  @IconDataConverter()
  @override
  final IconData iconData;

  AppWriteProfileLink({
    String? id,
    required this.link,
    required this.iconData,
  }) : id = id ?? randomUID();

  factory AppWriteProfileLink.fromJson(Map<String, dynamic> json) =>
      _$AppWriteProfileLinkFromJson(json);

  Map<String, dynamic> toJson() => _$AppWriteProfileLinkToJson(this);

  @override
  ProfileLink copyWith({
    String? link,
    IconData? iconData,
  }) =>
      AppWriteProfileLink(
        id: id,
        link: link ?? this.link,
        iconData: iconData ?? this.iconData,
      );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! ProfileLink || runtimeType != other.runtimeType) {
      return false;
    }
    return id == other.id && link == other.link && iconData == other.iconData;
  }

  @override
  int get hashCode {
    return id.hashCode ^ link.hashCode ^ iconData.hashCode;
  }

  @override
  String toString() {
    return 'ProfileLink{link: $link, iconData: ${iconData.codePoint}}';
  }
}

class ProfileLinkConverter
    implements JsonConverter<AppWriteProfileLink, Map<String, dynamic>> {
  const ProfileLinkConverter();

  @override
  AppWriteProfileLink fromJson(Map<String, dynamic> json) {
    return AppWriteProfileLink.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson(AppWriteProfileLink value) => value.toJson();
}

class IconDataConverter implements JsonConverter<IconData, String> {
  static const codePointKey = 'codePoint';
  static const fontFamilyKey = 'fontFamily';
  static const fontPackageKey = 'fontPackage';

  const IconDataConverter();

  @override
  IconData fromJson(String json) {
    final map = jsonDecode(json);
    final codePoint = map[codePointKey] as num;
    return IconData(
      codePoint.toInt(),
      fontFamily: map[fontFamilyKey] as String?,
      fontPackage: map[fontFamilyKey] as String?,
    );
  }

  @override
  String toJson(IconData value) => jsonEncode(<String, Object>{
        codePointKey: value.codePoint,
        fontFamilyKey: value.fontFamily ?? '',
        fontPackageKey: value.fontPackage ?? '',
      });
}
