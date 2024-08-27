import 'package:flutter/widgets.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:provider/provider.dart';

import '../common/route_path.dart';
import 'user.dart';

part 'auth.g.dart';

class AuthState extends ChangeNotifier {
  Auth? _auth;

  static AuthState of(BuildContext context, {bool listen = false}) {
    return Provider.of<AuthState>(context, listen: listen);
  }

  AuthState(this._auth);

  Auth? get auth => _auth;

  set auth(Auth? value) {
    _auth = value;
    notifyListeners();
  }

  RoutePath? redirectPathFor(RoutePath? path) {
    final routeIsAnonymous = path?.anonymous ?? false;
    final hasAuth = _auth != null;
    if (routeIsAnonymous == hasAuth) {
      // redirect to auth state as route don't match auth state needed
      return RoutePath.firstWithAnonymous(!hasAuth);
    }
    return null;
  }
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
