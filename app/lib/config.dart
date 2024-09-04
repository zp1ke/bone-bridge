class AppConfig {
  AppConfig._();

  static const appWriteProjectID = String.fromEnvironment('appWriteProjectID');
  static const appWriteTodosDatabaseID =
      String.fromEnvironment('appWriteTodosDatabaseID');
  static const appWriteTodosCollectionID =
      String.fromEnvironment('appWriteTodosCollectionID');
}
