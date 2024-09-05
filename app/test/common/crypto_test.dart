import 'package:app/common/string.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('encrypt / decrypt', () {
    final keyValues = <String, String>{
      'keyA': 'valueA',
      'keyB': 'valueB!',
      '34587s': 'sdfn43589ñ;!',
    };
    keyValues.forEach((key, value) {
      final encrypted = value.encrypt(plainKey: key);
      expect(encrypted, isNotEmpty);
      final decrypted = encrypted.decrypt(plainKey: key);
      expect(decrypted, equals(value));
    });
  });

  test('sha256', () {
    final keyValues = <String, String>{
      'keya':
          '69a9f50a51e4591ec3ff1a34520b08e7a26cf00312183f7a42bb226ab9262288',
      'keyb':
          'f678b61e51c1061dac3741cfbc8ac4c5b579dce364bea0a0090ee680c1396f61',
      '34587s':
          'aa661a1a38f88667091c775a6f38a78744cac9a8251f1e9fcba9c32a2623c029',
    };
    keyValues.forEach((key, value) {
      final sha256 = key.sha256;
      expect(sha256, isNotEmpty);
      expect(sha256, equals(value));
    });
  });
}
