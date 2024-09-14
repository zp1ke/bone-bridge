import 'package:flutter/material.dart';

import '../model/profile.dart';
import '../state/auth.dart';

abstract class ProfileService {
  Future<Profile?> fetchProfile(Auth auth);

  Profile createProfile();

  Future<Profile> saveProfile(Auth auth, Profile profile);

  Future<Profile?> fetchPublicProfile(String username);

  ProfileLink createProfileLink({
    required String link,
    required IconData iconData,
  });
}
