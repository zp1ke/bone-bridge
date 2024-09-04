import '../model/auth.dart';

abstract class Credentials {}

abstract class AuthService {
  Future setup(Auth? auth);

  Future<Auth> authenticate(Credentials credentials);

  Auth? parse(Map<String, dynamic> authMap);

  Future clear();
}

class UsernamePasswordCredentials implements Credentials {
  final String username;
  final String password;

  UsernamePasswordCredentials({
    required this.username,
    required this.password,
  });
}
