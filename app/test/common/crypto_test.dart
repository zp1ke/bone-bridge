import 'package:app/common/crypto.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('encrypt / decrypt', () {
    final keyValues = <String, String>{
      'keyA': 'valueA',
      'keyB': 'valueB!',
      '34587s': 'sdfn43589ñ;!',
    };
    keyValues.forEach((key, value) {
      final encrypted = encrypt(plainKey: key, plainText: value);
      expect(encrypted, isNotEmpty);
      final decrypted = decrypt(plainKey: key, base64Text: encrypted);
      expect(decrypted, equals(value));
    });
  });
}
