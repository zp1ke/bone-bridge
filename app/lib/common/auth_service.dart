import '../model/auth.dart';

abstract class Credentials {}

abstract class AuthService {
  Future<Auth> authenticate(Credentials credentials);
}

class UsernamePasswordCredentials implements Credentials {
  final String username;
  final String password;

  UsernamePasswordCredentials({
    required this.username,
    required this.password,
  });
}
