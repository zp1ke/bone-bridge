import 'package:app/app/route_path.dart';
import 'package:app/state/auth.dart';
import 'package:flutter_test/flutter_test.dart';

import '../common/fake_auth_service.dart';
import '../common/mem_storage_service.dart';

void main() {
  final authService = FakeAuthService();
  final storageService = MemoryStorageService();

  test('Redirect path for no auth and accessing home', () async {
    final authState = await AuthState.create(
      authService: authService,
      storageService: storageService,
    );
    final redirectPath = authState.redirectPathFor(RoutePath.home);
    expect(redirectPath, equals(RoutePath.signIn));
  });

  test('Redirect path for auth and accessing sign-in', () async {
    final authState = await AuthState.create(
      authService: authService,
      storageService: storageService,
      auth: authService.auth,
    );
    final redirectPath = authState.redirectPathFor(RoutePath.signIn);
    expect(redirectPath, equals(RoutePath.home));
  });

  test('Redirect path for auth and accessing home', () async {
    final authState = await AuthState.create(
      authService: authService,
      storageService: storageService,
      auth: authService.auth,
    );
    final redirectPath = authState.redirectPathFor(RoutePath.home);
    expect(redirectPath, isNull);
  });
}
