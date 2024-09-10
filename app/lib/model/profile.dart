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
}
