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

      final String message = 'Hello world!';

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
        'Handling incorrect public key length',
        () {
          final signedMessage = sphincsPlus.sign(
            message: message,
            secretKey: secretKey,
          );

          final invalidPublicKey = Uint8List.fromList(
            List.generate(sphincsPlus.pkLength + 100, (_) => 1),
          );

          expect(
            () => sphincsPlus.verify(
              message: message,
              signedMessage: signedMessage,
              publicKey: invalidPublicKey,
            ),
            throwsException,
          );
        },
      );

      test(
        'Handling incorrect signed message length',
        () {
          final invalidSignedMessage = Uint8List.fromList(
            List.generate(
              sphincsPlus.signatureLength + message.length + 100,
              (_) => 1,
            ),
          );

          expect(
            () => sphincsPlus.verify(
              message: message,
              signedMessage: invalidSignedMessage,
              publicKey: publicKey,
            ),
            throwsException,
          );
        },
      );
    },
  );
}
