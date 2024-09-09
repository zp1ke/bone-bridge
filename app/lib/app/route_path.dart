enum RoutePath {
  signIn('/sign-in', anonymous: true),
  home('/'),
  profile('/p', anonymous: true);

  final String path;
  final bool anonymous;

  const RoutePath(this.path, {this.anonymous = false});

  static RoutePath? parse(String path) {
    final matches = RoutePath.values.where((value) => value.name == path);
    return matches.isNotEmpty ? matches.first : null;
  }

  static RoutePath firstWithAnonymous(bool anonymous) {
    return RoutePath.values.firstWhere((value) => value.anonymous == anonymous);
  }
}
