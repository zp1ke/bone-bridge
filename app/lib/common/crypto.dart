import 'package:encrypt/encrypt.dart';

String encrypt({required String plainKey, required String plainText}) {
  final iv = IV.fromUtf8(plainKey);
  return _encrypterOf(plainKey).encrypt(plainText, iv: iv).base64;
}

String decrypt({required String plainKey, required String base64Text}) {
  final iv = IV.fromUtf8(plainKey);
  return _encrypterOf(plainKey)
      .decrypt(Encrypted.fromBase64(base64Text), iv: iv);
}

Encrypter _encrypterOf(String plainKey) {
  final key32 = plainKey.padRight(32, plainKey[plainKey.length - 1]);
  final key = Key.fromUtf8(key32);
  return Encrypter(AES(key));
}
