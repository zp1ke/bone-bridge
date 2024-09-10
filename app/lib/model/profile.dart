import '../common/string.dart';
import '../state/auth.dart';

abstract class Profile {
  String get id;

  bool get isNew;

  String get username;

  set username(String value);

  bool get isPublic;

  set isPublic(bool value);

  String get name;

  set name(String value);

  String get summary;

  set summary(String value);

  String get asJson;

  Profile copyWith({
    String? username,
    bool? isPublic,
    String? name,
    String? summary,
  });

  static String imageKey(Auth auth) {
    return '${auth.id}-image';
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
