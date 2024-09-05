import '../common/string.dart';

abstract class User {
  String get id;

  String get email;

  String get username;

  String? get firstName;

  String? get lastName;

  String? get fullName {
    if (firstName != null || lastName != null) {
      return '${firstName ?? ''} ${lastName ?? ''}'.trim();
    }
    return null;
  }

  String? get image;

  String get gravatarUrl {
    final hash = email.sha256;
    return 'https://gravatar.com/avatar/$hash';
  }

  String get asJson;
}
