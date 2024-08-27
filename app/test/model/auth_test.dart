import 'package:app/common/route_path.dart';
import 'package:app/model/auth.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Redirect path for no auth and accessing home', () {
    final authState = AuthState(null);
    final redirectPath = authState.redirectPathFor(RoutePath.home);
    expect(redirectPath, equals(RoutePath.signIn));
  });

  test('Redirect path for auth and accessing sign-in', () {
    final authState = AuthState(testAuth());
    final redirectPath = authState.redirectPathFor(RoutePath.signIn);
    expect(redirectPath, equals(RoutePath.home));
  });

  test('Redirect path for auth and accessing home', () {
    final authState = AuthState(testAuth());
    final redirectPath = authState.redirectPathFor(RoutePath.home);
    expect(redirectPath, isNull);
  });
}

Auth testAuth() {
  return Auth(
    id: 1,
    email: 'test@mail.com',
    username: 'username',
    token: 'token',
    refreshToken: 'refreshToken',
  );
}
