import 'dart:typed_data';

import 'package:sphincs_plus/sphincs_plus_dart.dart';
import 'package:test/test.dart';

void main() {
  print('\n');
  group(
    'SPHINCS+ integrity check:',
    () {
      final sphincsPlus = SphincsPlus();

      final Uint8List publicKey;
      final Uint8List secretKey;

      (publicKey, secretKey) = sphincsPlus.generateKeyPair();

      final String message = 'Hello world!';

      test(
        'Altered message should fail verification',
        () {
          final signedMessage = sphincsPlus.sign(
            message: message,
            secretKey: secretKey,
          );

          final alteredMessage = 'a' * message.length;

          bool isValid = sphincsPlus.verify(
            message: alteredMessage,
            signedMessage: signedMessage,
            publicKey: publicKey,
          );

          expect(isValid, isFalse);
        },
      );

      test(
        'Altered signature should fail verification',
        () {
          final alteredSignedMessage = Uint8List.fromList(
            List.generate(
              sphincsPlus.signatureLength + message.length,
              (_) => 1,
            ),
          );

          bool isValid = sphincsPlus.verify(
            message: message,
            signedMessage: alteredSignedMessage,
            publicKey: publicKey,
          );

          expect(isValid, isFalse);
        },
      );

      test(
        'Altered public key should fail verification',
        () {
          final signedMessage = sphincsPlus.sign(
            message: message,
            secretKey: secretKey,
          );

          final alteredPublicKey = Uint8List.fromList(
            List.generate(sphincsPlus.pkLength, (_) => 1),
          );

          bool isValid = sphincsPlus.verify(
            message: message,
            signedMessage: signedMessage,
            publicKey: alteredPublicKey,
          );

          expect(isValid, isFalse);
        },
      );
    },
  );
}
