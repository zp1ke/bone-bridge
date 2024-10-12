import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../../model/data_page.dart';
import '../../model/profile.dart';
import '../../model/todo.dart';
import '../../state/auth.dart';
import 'dart:typed_data';

import '../auth_service.dart';
import '../profile_service.dart';
import '../storage_service.dart';
import '../todo_service.dart';
import 'firebase_config.dart';

class FirebaseService
    implements AuthService, TodoService, ProfileService, StorageService {
  static Future<FirebaseService> create() async {
    await Firebase.initializeApp(
      options: FirebaseConfig.platformOptions,
    );
    return FirebaseService._();
  }

  FirebaseService._();

  // https://firebase.google.com/docs/auth/flutter/password-auth?hl=en&authuser=0
  @override
  Future<Auth> authenticate(Credentials credentials) async {
    if (credentials is! UsernamePasswordCredentials) {
      throw UnimplementedError();
    }

    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: credentials.username,
        password: credentials.password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Future clear() {
    // TODO: implement clear
    throw UnimplementedError();
  }

  @override
  Profile createProfile() {
    // TODO: implement createProfile
    throw UnimplementedError();
  }

  @override
  ProfileLink createProfileLink(
      {required String link, required IconData iconData}) {
    // TODO: implement createProfileLink
    throw UnimplementedError();
  }

  @override
  Todo createTodo() {
    // TODO: implement createTodo
    throw UnimplementedError();
  }

  @override
  Future<Profile?> fetchProfile(Auth auth) {
    // TODO: implement fetchProfile
    throw UnimplementedError();
  }

  @override
  Future<Profile?> fetchPublicProfile(String username) {
    // TODO: implement fetchPublicProfile
    throw UnimplementedError();
  }

  @override
  Future<DataPage<Todo>> fetchTodos(Auth auth,
      {required int page, required int pageSize}) {
    // TODO: implement fetchTodos
    throw UnimplementedError();
  }

  @override
  Future<Uint8List?> getFile({required String key}) {
    // TODO: implement getFile
    throw UnimplementedError();
  }

  @override
  Future saveFile(Auth auth,
      {required String key, required String name, required Uint8List bytes}) {
    // TODO: implement saveFile
    throw UnimplementedError();
  }

  @override
  Future<Profile> saveProfile(Auth auth, Profile profile) {
    // TODO: implement saveProfile
    throw UnimplementedError();
  }

  @override
  Future<Todo> saveTodo(Auth auth, Todo todo) {
    // TODO: implement saveTodo
    throw UnimplementedError();
  }

  @override
  Future<Auth?> setupAuth(Map<String, dynamic> authMap) {
    // TODO: implement setupAuth
    throw UnimplementedError();
  }
}
