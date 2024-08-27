import '../model/auth.dart';

abstract class Credentials {}

abstract class AuthService {
  Future<Auth> authenticate(Credentials credentials);
}
