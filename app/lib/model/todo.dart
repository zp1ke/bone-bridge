abstract class Todo {
  String get id;

  bool get isNew;

  String get description;

  set description(String value);

  bool get isCompleted;

  set isCompleted(bool value);
}
