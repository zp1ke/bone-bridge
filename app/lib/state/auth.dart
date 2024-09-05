import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../app/route_path.dart';
import '../common/crypto.dart';
import '../common/locator.dart';
import '../service/auth_service.dart';
import '../service/storage_service.dart';
import '../model/user.dart';

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

  Auth? get auth => _auth;

  static Future<AuthState> create({
    AuthService? authService,
    StorageService? storageService,
    Auth? auth,
  }) async {
    final authServ = authService ?? getService<AuthService>();
    final storageServ = storageService ?? getService<StorageService>();

    if (auth != null) {
      return AuthState._(
        authService: authServ,
        storageService: storageServ,
        auth: auth,
      );
    }
    final username = await storageServ.loadString(_usernameKey);
    Auth? savedAuth;
    if (username != null) {
      var authJson = await storageServ.loadString(_userJsonKey);
      authJson = authJson!.decrypt(plainKey: username);
      final Map<String, dynamic> authMap = jsonDecode(authJson);
      savedAuth = await authServ.setupAuth(authMap);
    }
    return AuthState._(
      authService: authServ,
      storageService: storageServ,
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
    final authJson = _auth!.asJson.encrypt(plainKey: _auth!.username);
    await _storageService.saveString(key: _userJsonKey, value: authJson);
    notifyListeners();
  }

  static Future signOut(BuildContext context) {
    return AuthState.of(context).clear();
  }

  Future clear() async {
    await _authService.clear();
    await _storageService.clear();
    _auth = null;
    notifyListeners();
  }
}
