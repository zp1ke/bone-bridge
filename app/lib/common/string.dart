import 'dart:convert';

import 'package:crypto/crypto.dart' as crypto;
import 'package:encrypt/encrypt.dart';
import 'package:string_similarity/string_similarity.dart';
import 'package:uuid/uuid.dart';

String randomUID() {
  return const Uuid().v4().replaceAll('-', '').substring(0, 20);
}

extension AppString on String {
  String encrypt({required String plainKey}) {
    final iv = IV.fromUtf8(plainKey);
    return _encrypterOf(plainKey).encrypt(this, iv: iv).base64;
  }

  String decrypt({required String plainKey}) {
    final iv = IV.fromUtf8(plainKey);
    return _encrypterOf(plainKey).decrypt(Encrypted.fromBase64(this), iv: iv);
  }

  String get sha256 {
    final bytesToHash = utf8.encode(trim().toLowerCase());
    final sha256Digest = crypto.sha256.convert(bytesToHash);
    return sha256Digest.toString();
  }

  bool hasSimilarityTo(String other) {
    return similarityTo(other) >= 0.7;
  }
}

Encrypter _encrypterOf(String plainKey) {
  final key32 = plainKey.padRight(32, plainKey[plainKey.length - 1]);
  final key = Key.fromUtf8(key32);
  return Encrypter(AES(key));
}
