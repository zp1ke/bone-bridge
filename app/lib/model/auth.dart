import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../app/route_path.dart';
import '../common/crypto.dart';
import '../service/auth_service.dart';
import '../service/storage_service.dart';
import 'user.dart';

abstract class Auth extends User {
  String get token;

  String get refreshToken;
}

const _usernameKey = 'auth_username';
const _userJsonKey = 'auth_json';

class AuthState extends ChangeNotifier {
  final AuthService _authService;
  final StorageService _storageService;
  Auth? _auth;

  static AuthState of(BuildContext context, {bool listen = false}) {
    return Provider.of<AuthState>(context, listen: listen);
  }

  static Future<AuthState> create({
    required AuthService authService,
    required StorageService storageService,
    Auth? auth,
  }) async {
    if (auth != null) {
      return AuthState._(
        authService: authService,
        storageService: storageService,
        auth: auth,
      );
    }
    final username = await storageService.loadString(_usernameKey);
    Auth? savedAuth;
    if (username != null) {
      var authJson = await storageService.loadString(_userJsonKey);
      authJson = decrypt(plainKey: username, base64Text: authJson!);
      final Map<String, dynamic> authMap = jsonDecode(authJson);
      savedAuth = authService.parse(authMap);
    }
    return AuthState._(
      authService: authService,
      storageService: storageService,
      auth: savedAuth,
    );
  }

  AuthState._({
    required AuthService authService,
    required StorageService storageService,
    Auth? auth,
  })  : _auth = auth,
        _authService = authService,
        _storageService = storageService;

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
    await _storageService.saveString(key: _usernameKey, value: _auth!.username);
    final authJson =
        encrypt(plainKey: _auth!.username, plainText: _auth!.asJson);
    await _storageService.saveString(key: _userJsonKey, value: authJson);
    notifyListeners();
  }

  Future signOut() async {
    await _storageService.clear();
    notifyListeners();
  }
}
