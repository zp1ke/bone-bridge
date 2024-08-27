import 'package:app/common/auth_service.dart';
import 'package:app/model/auth.dart';

class EmptyCredentials implements Credentials {}

class FakeAuthService implements AuthService {
  final Auth auth = Auth(
    id: 1,
    email: 'test@mail.com',
    username: 'username',
    token: 'token',
    refreshToken: 'refreshToken',
  );

  @override
  Future<Auth> authenticate(Credentials credentials) {
    return Future.value(auth);
  }
}
