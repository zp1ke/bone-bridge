import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../app/route_path.dart';
import '../service/auth_service.dart';
import 'user.dart';

abstract class Auth extends User {
  String get token;

  String get refreshToken;
}

class AuthState extends ChangeNotifier {
  final AuthService _authService;
  Auth? _auth;

  static AuthState of(BuildContext context, {bool listen = false}) {
    return Provider.of<AuthState>(context, listen: listen);
  }

  AuthState({
    required AuthService authService,
    Auth? auth,
  })  : _auth = auth,
        _authService = authService;

  Auth? get auth => _auth;

  RoutePath? redirectPathFor(RoutePath? path) {
    final routeIsAnonymous = path?.anonymous ?? false;
    final hasAuth = _auth != null;
    if (routeIsAnonymous == hasAuth) {
      // redirect to auth state as route don't match auth state needed
      return RoutePath.firstWithAnonymous(!hasAuth);
    }
    return null;
  }

  Future authenticate(Credentials credentials) async {
    _auth = await _authService.authenticate(credentials);
    notifyListeners();
  }
}
