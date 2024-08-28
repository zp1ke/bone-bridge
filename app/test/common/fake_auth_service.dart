import 'package:app/model/auth.dart';
import 'package:app/service/auth_service.dart';

class EmptyCredentials implements Credentials {}

class FakeAuthService implements AuthService {
  final Auth auth = FakeAuth(
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

  @override
  Auth? parse(Map<String, dynamic> authMap) {
    return auth;
  }
}

class FakeAuth extends Auth {
  @override
  final String email;

  @override
  final String? firstName;

  @override
  int id;

  @override
  final String? image;

  @override
  final String? lastName;

  @override
  final String refreshToken;

  @override
  final String token;

  @override
  final String username;

  FakeAuth({
    required this.email,
    this.firstName,
    required this.id,
    this.image,
    this.lastName,
    required this.refreshToken,
    required this.token,
    required this.username,
  });

  @override
  String get asJson => username;
}
