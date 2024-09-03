import 'package:appwrite/appwrite.dart';

import '../../model/auth.dart';
import '../auth_service.dart';
import 'app_write_model.dart';

// https://appwrite.io/docs
class AppWriteService implements AuthService {
  final Client _client;
  late Account _account;

  AppWriteService({required String projectID}) : _client = Client() {
    _client
        .setEndpoint('https://cloud.appwrite.io/v1')
        .setProject(projectID)
        // For self signed certificates, only use for development
        .setSelfSigned(status: true);
    _account = Account(_client);
  }

  @override
  Future<Auth> authenticate(Credentials credentials) async {
    if (credentials is! UsernamePasswordCredentials) {
      throw UnimplementedError();
    }

    final session = await _account.createEmailPasswordSession(
      email: credentials.username,
      password: credentials.password,
    );
    final user = await _account.get();
    return AppWriteAuth(
      id: session.userId,
      email: user.email,
      username: user.name,
      firstName: user.name,
      token: session.providerAccessToken,
      refreshToken: session.providerRefreshToken,
    );
  }

  @override
  Auth? parse(Map<String, dynamic> authMap) {
    return AppWriteAuth.fromJson(authMap);
  }

  @override
  Future clear() {
    return _account.deleteSessions();
  }
}
