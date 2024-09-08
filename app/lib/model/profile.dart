abstract class Profile {
  String get id;

  bool get isNew;

  String get username;

  set username(String value);

  bool get isPublic;

  set isPublic(bool value);

  String get asJson;
}
