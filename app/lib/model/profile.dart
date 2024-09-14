import 'package:flutter/material.dart';

import '../common/string.dart';

abstract class Profile {
  String get id;

  String get userId;

  bool get isNew;

  String get username;

  set username(String value);

  bool get isPublic;

  set isPublic(bool value);

  String get name;

  set name(String value);

  String get summary;

  set summary(String value);

  Set<ProfileLink> get links;

  void addLink(ProfileLink link);

  String get asJson;

  Profile copyWith({
    String? username,
    bool? isPublic,
    String? name,
    String? summary,
    Set<ProfileLink>? links,
  });

  static String imageKey(String id) {
    return '$id-image';
  }

  static String imageUrl({
    Profile? profile,
    String? username,
    required double radius,
  }) {
    var key = profile?.username ?? username ?? randomUID();
    if (key.isEmpty) {
      key = randomUID();
    }
    return 'https://dummyjson.com/icon/$key/${radius * 2}';
  }
}

abstract class ProfileLink {
  String get id;

  String get link;

  IconData get iconData;

  ProfileLink copyWith({
    String? link,
    IconData? iconData,
  });
}
