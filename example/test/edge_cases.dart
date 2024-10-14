import 'dart:typed_data';

import 'package:sphincs_plus/sphincs_plus_dart.dart';
import 'package:test/test.dart';

void main() {
  print('\n');
  group(
    'SPHINCS+ edge cases:',
    () {
      final sphincsPlus = SphincsPlus();

      final Uint8List publicKey;
      final Uint8List secretKey;

      (publicKey, secretKey) = sphincsPlus.generateKeyPair();

      test(
        'Signing and verifying a long message',
        () {
          final longMessage = 'a' * 100000;

          final signedMessage = sphincsPlus.sign(
            message: longMessage,
            secretKey: secretKey,
          );

          expect(signedMessage, isNotNull);
          expect(
            signedMessage.length,
            equals(longMessage.length + sphincsPlus.signatureLength),
          );

          bool isValid = sphincsPlus.verify(
            message: longMessage,
            signedMessage: signedMessage,
            publicKey: publicKey,
          );

          expect(isValid, isTrue);
        },
      );

      test(
        'Signing and verifying an empty message',
        () {
          final emptyMessage = '';

          final signedMessage = sphincsPlus.sign(
            message: emptyMessage,
            secretKey: secretKey,
          );

          expect(signedMessage, isNotNull);
          expect(
            signedMessage.length,
            equals(emptyMessage.length + sphincsPlus.signatureLength),
          );

          bool isValid = sphincsPlus.verify(
            message: emptyMessage,
            signedMessage: signedMessage,
            publicKey: publicKey,
          );

          expect(isValid, isTrue);
        },
      );

      test(
        'Signing and verifying a message with non-UTF-8 characters',
        () {
          final nonUtf8Message = 'Hello wörld!';

          final signedMessage = sphincsPlus.sign(
            message: nonUtf8Message,
            secretKey: secretKey,
          );

          expect(signedMessage, isNotNull);
          expect(
            signedMessage.length,
            equals(nonUtf8Message.length + sphincsPlus.signatureLength),
          );

          bool isValid = sphincsPlus.verify(
            message: nonUtf8Message,
            signedMessage: signedMessage,
            publicKey: publicKey,
          );

          expect(isValid, isTrue);
        },
      );
    },
  );
}
