import 'dart:typed_data';

import 'package:sphincs_plus/sphincs_plus_dart.dart';
import 'package:test/test.dart';

void main() {
  print('\n');
  group(
    'SPHINCS+ base functions:',
    () {
      final sphincsPlus = SphincsPlus();

      late Uint8List publicKey;
      late Uint8List secretKey;
      final String message = 'Hello world!';
      late final Uint8List signedMessage;
      late final bool isValid;

      test(
        'Key generation without a seed',
        () {
          (publicKey, secretKey) = sphincsPlus.generateKeyPair();

          expect(publicKey, isNotNull);
          expect(publicKey.length, equals(sphincsPlus.pkLength));

          expect(secretKey, isNotNull);
          expect(secretKey.length, equals(sphincsPlus.skLength));
        },
      );

      test(
        'Key generation with a seed',
        () {
          final String seed = 'a' * sphincsPlus.seedLength;
          (publicKey, secretKey) = sphincsPlus.generateKeyPair(seed: seed);

          expect(publicKey, isNotNull);
          expect(publicKey.length, equals(sphincsPlus.pkLength));

          expect(secretKey, isNotNull);
          expect(secretKey.length, equals(sphincsPlus.skLength));
        },
      );

      test(
        'Signature of a message',
        () {
          signedMessage = sphincsPlus.sign(
            message: message,
            secretKey: secretKey,
          );

          expect(signedMessage, isNotNull);
          expect(
            signedMessage.length,
            equals(message.length + sphincsPlus.signatureLength),
          );
        },
      );

      test(
        'Verification of a signed message',
        () {
          isValid = sphincsPlus.verify(
            message: message,
            publicKey: publicKey,
            signedMessage: signedMessage,
          );

          expect(isValid, isNotNull);
          expect(isValid, isTrue);
        },
      );
    },
  );
}
