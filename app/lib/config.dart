class AppConfig {
  AppConfig._();

  // common
  static int get defaultPaginationSize => paginationSizes.first;
  static final paginationSizes =
      const String.fromEnvironment('paginationSizes', defaultValue: '10 20 50')
          .split(' ')
          .map((size) => int.parse(size))
          .toList();
  static const webBaseUrl = String.fromEnvironment('webBaseUrl',
      defaultValue: 'https://sp1ke.dev/bone-bridge');

  // appwrite
  static const appwriteProjectID = String.fromEnvironment('appwriteProjectID');
  static const appwriteTodosDbID = String.fromEnvironment('appwriteTodosDbID');
  static const appwriteTodosLotID =
      String.fromEnvironment('appwriteTodosLotID');
  static const appwriteProfilesDbID =
      String.fromEnvironment('appwriteProfilesDbID');
  static const appwriteProfilesLotID =
      String.fromEnvironment('appwriteProfilesLotID');
  static const appwriteStorageBucket =
      String.fromEnvironment('appwriteStorageBucket');

  // firebase
  static const firebaseWebApiKey = String.fromEnvironment('firebaseWebApiKey');
  static const firebaseWebAppId = String.fromEnvironment('firebaseWebAppId');
  static const firebaseAndroidApiKey =
      String.fromEnvironment('firebaseAndroidApiKey');
  static const firebaseAndroidAppId =
      String.fromEnvironment('firebaseAndroidAppId');
  static const firebaseMessagingSenderId =
      String.fromEnvironment('firebaseMessagingSenderId');
  static const firebaseProjectId = String.fromEnvironment('firebaseProjectId');
  static const firebaseAuthDomain =
      String.fromEnvironment('firebaseAuthDomain');
  static const firebaseStorageBucket =
      String.fromEnvironment('firebaseStorageBucket');
}
