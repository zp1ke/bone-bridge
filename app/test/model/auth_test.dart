import 'package:app/app/route_path.dart';
import 'package:app/model/auth.dart';
import 'package:flutter_test/flutter_test.dart';

import '../common/fake_auth_service.dart';

void main() {
  final authService = FakeAuthService();

  test('Redirect path for no auth and accessing home', () {
    final authState = AuthState(authService: authService);
    final redirectPath = authState.redirectPathFor(RoutePath.home);
    expect(redirectPath, equals(RoutePath.signIn));
  });

  test('Redirect path for auth and accessing sign-in', () {
    final authState = AuthState(
      authService: authService,
      auth: authService.auth,
    );
    final redirectPath = authState.redirectPathFor(RoutePath.signIn);
    expect(redirectPath, equals(RoutePath.home));
  });

  test('Redirect path for auth and accessing home', () {
    final authState = AuthState(
      authService: authService,
      auth: authService.auth,
    );
    final redirectPath = authState.redirectPathFor(RoutePath.home);
    expect(redirectPath, isNull);
  });
}
