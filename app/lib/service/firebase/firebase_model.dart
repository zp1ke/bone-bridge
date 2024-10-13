import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../common/string.dart';
import '../../model/profile.dart';
import '../../model/todo.dart';
import '../../model/user.dart';
import '../../state/auth.dart';
import '../../model/icon_data_converter.dart';

part 'firebase_model.g.dart';

@JsonSerializable()
class FirebaseAppUser extends User {
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

  FirebaseAppUser({
    required this.id,
    required this.email,
    required this.username,
    this.firstName,
    this.lastName,
    this.image,
  });

  Map<String, dynamic> toJson() => _$FirebaseAppUserToJson(this);

  @override
  String get asJson => jsonEncode(toJson());
}

@JsonSerializable()
class FirebaseAppAuth extends FirebaseAppUser implements Auth {
  @override
  final String token;
  @override
  final String refreshToken;

  FirebaseAppAuth({
    required super.id,
    required super.email,
    required super.username,
    super.firstName,
    super.lastName,
    super.image,
    required this.token,
    required this.refreshToken,
  });

  factory FirebaseAppAuth.fromUserCredential(
      firebase.UserCredential userCredential) {
    final user = userCredential.user!;
    return FirebaseAppAuth(
      id: user.uid,
      email: user.email ?? '',
      username: user.email ?? '',
      firstName: user.displayName?.firstName,
      lastName: user.displayName?.lastName,
      image: user.photoURL,
      token: userCredential.credential?.accessToken ?? '',
      refreshToken: user.refreshToken ?? '',
    );
  }

  factory FirebaseAppAuth.fromUser(firebase.User user) => FirebaseAppAuth(
        id: user.uid,
        email: user.email ?? '',
        username: user.email ?? '',
        token: user.uid,
        refreshToken: '',
      );

  @override
  Map<String, dynamic> toJson() => _$FirebaseAppAuthToJson(this);

  @override
  String get asJson => jsonEncode(toJson());
}

@JsonSerializable()
class FirebaseAppTodo extends Todo {
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

  FirebaseAppTodo({
    required this.id,
    required this.description,
    this.isCompleted = false,
  });

  factory FirebaseAppTodo.fromJson(Map<String, dynamic> json) =>
      _$FirebaseAppTodoFromJson(json);

  factory FirebaseAppTodo.fromDocument(Object document) {
    // final map = document.data;
    // map['id'] = document.$id;
    return FirebaseAppTodo.fromJson({});
  }

  Map<String, dynamic> toJson() => _$FirebaseAppTodoToJson(this);
}

@JsonSerializable()
class FirebaseAppProfile extends Profile {
  static const userIdKey = 'user_id';
  static const usernameKey = 'username';
  static const isPublicKey = 'is_public';

  @JsonKey(includeToJson: false)
  @override
  final String id;

  @JsonKey(name: userIdKey)
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
  final Set<FirebaseProfileLink> links;

  FirebaseAppProfile({
    required this.id,
    required this.userId,
    required this.username,
    required this.isPublic,
    this.name = '',
    this.summary = '',
    required this.links,
  });

  factory FirebaseAppProfile.fromJson(Map<String, dynamic> json) {
    final map = Map.of(json);
    var linksKey = 'links';
    final defaultsMap = <String, Object>{
      usernameKey: map[userIdKey]!,
      isPublicKey: false,
    };
    defaultsMap.forEach((key, value) {
      if (map[key] == null) {
        map[key] = value;
      }
    });
    if (json[linksKey] is List) {
      map[linksKey] =
          (json[linksKey] as List).map((item) => jsonDecode(item)).toList();
    } else {
      map[linksKey] = [];
    }
    return _$FirebaseAppProfileFromJson(map);
  }

  factory FirebaseAppProfile.fromDocument(Object document) {
    // final map = document.data;
    // map['id'] = document.$id;
    return FirebaseAppProfile.fromJson({});
  }

  Map<String, dynamic> toJson() {
    final map = _$FirebaseAppProfileToJson(this);
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
      FirebaseAppProfile(
        id: id,
        userId: userId,
        username: username ?? this.username,
        isPublic: isPublic ?? this.isPublic,
        name: name ?? this.name,
        summary: summary ?? this.summary,
        links: links?.map((link) => link as FirebaseProfileLink).toSet() ??
            this.links,
      );

  @override
  void addLink(ProfileLink link) {
    if (link is! FirebaseProfileLink) {
      throw UnimplementedError();
    }
  }
}

@JsonSerializable()
class FirebaseProfileLink extends ProfileLink {
  @JsonKey(includeToJson: false, includeFromJson: false)
  @override
  final String id;

  @override
  final String link;

  @IconDataConverter()
  @override
  final IconData iconData;

  FirebaseProfileLink({
    String? id,
    required this.link,
    required this.iconData,
  }) : id = id ?? randomUID();

  factory FirebaseProfileLink.fromJson(Map<String, dynamic> json) =>
      _$FirebaseProfileLinkFromJson(json);

  Map<String, dynamic> toJson() => _$FirebaseProfileLinkToJson(this);

  @override
  ProfileLink copyWith({
    String? link,
    IconData? iconData,
  }) =>
      FirebaseProfileLink(
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
    return 'FirebaseProfileLink{link: $link, iconData: ${iconData.codePoint}}';
  }
}

class ProfileLinkConverter
    implements JsonConverter<FirebaseProfileLink, Map<String, dynamic>> {
  const ProfileLinkConverter();

  @override
  FirebaseProfileLink fromJson(Map<String, dynamic> json) {
    return FirebaseProfileLink.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson(FirebaseProfileLink value) => value.toJson();
}
