import 'package:flutter/widgets.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:provider/provider.dart';

import '../app/route_path.dart';
import '../common/auth_service.dart';
import 'user.dart';

part 'auth.g.dart';

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

class UsernamePasswordCredentials implements Credentials {
  final String username;
  final String password;

  UsernamePasswordCredentials({
    required this.username,
    required this.password,
  });
}

@JsonSerializable()
class Auth extends User {
  final String token;
  final String refreshToken;

  Auth({
    required super.id,
    required super.email,
    required super.username,
    super.firstName,
    super.lastName,
    super.image,
    required this.token,
    required this.refreshToken,
  });

  factory Auth.fromJson(Map<String, dynamic> json) => _$AuthFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$AuthToJson(this);
}
