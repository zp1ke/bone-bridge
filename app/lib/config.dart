class AppConfig {
  AppConfig._();

  // common
  static int get defaultPaginationSize => paginationSizes.first;
  static final paginationSizes =
      const String.fromEnvironment('paginationSizes', defaultValue: '10 20 50')
          .split(' ')
          .map((size) => int.parse(size))
          .toList();

  // appwrite
  static const appwritProjectID = String.fromEnvironment('appwriteProjectID');
  static const appwritTodosDbID = String.fromEnvironment('appwriteTodosDbID');
  static const appwritTodosLotID = String.fromEnvironment('appwriteTodosLotID');
}
