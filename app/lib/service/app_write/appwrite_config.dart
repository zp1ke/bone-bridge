import '../../config.dart';

class AppWriteConfig {
  final String serverUrl;
  final String projectID;
  final String todosDbId;
  final String todosLotId;
  final String profilesDbId;
  final String profilesLotId;
  final String storageBucket;

  AppWriteConfig._({
    required this.serverUrl,
    required this.projectID,
    required this.todosDbId,
    required this.todosLotId,
    required this.profilesDbId,
    required this.profilesLotId,
    required this.storageBucket,
  });

  factory AppWriteConfig.create() => AppWriteConfig._(
        serverUrl: 'https://cloud.appwrite.io/v1',
        projectID: AppConfig.appwriteProjectID,
        todosDbId: AppConfig.appwriteTodosDbID,
        todosLotId: AppConfig.appwriteTodosLotID,
        profilesDbId: AppConfig.appwriteProfilesDbID,
        profilesLotId: AppConfig.appwriteProfilesLotID,
        storageBucket: AppConfig.appwriteStorageBucket,
      );

  bool get isValid => projectID.isNotEmpty;

  bool get canHandleTodos => todosDbId.isNotEmpty && todosLotId.isNotEmpty;

  bool get canHandleProfiles =>
      profilesDbId.isNotEmpty && profilesLotId.isNotEmpty;

  bool get canHandleStorage => storageBucket.isNotEmpty;
}
