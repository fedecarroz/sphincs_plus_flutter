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

      test(
        'Key generation without a seed performance',
        () {
          final stopwatch = Stopwatch()..start();
          (publicKey, secretKey) = sphincsPlus.generateKeyPair();
          stopwatch.stop();

          final elapsedTime = stopwatch.elapsed.inMicroseconds / 1000;
          print(
            'Key generation without a seed performed in ${elapsedTime.toStringAsFixed(2)} ms',
          );
        },
      );

      test(
        'Key generation with a seed performance',
        () {
          final String seed = 'a' * sphincsPlus.seedLength;
          final stopwatch = Stopwatch()..start();
          (publicKey, secretKey) = sphincsPlus.generateKeyPair(seed: seed);
          stopwatch.stop();

          final elapsedTime = stopwatch.elapsed.inMicroseconds / 1000;
          print(
            'Key generation with a seed performed in ${elapsedTime.toStringAsFixed(2)} ms',
          );
        },
      );

      test(
        'Signature of a message performance',
        () {
          final stopwatch = Stopwatch()..start();
          signedMessage = sphincsPlus.sign(
            message: message,
            secretKey: secretKey,
          );
          stopwatch.stop();

          final elapsedTime = stopwatch.elapsed.inMicroseconds / 1000;
          print(
            'Signature of a message performed in ${elapsedTime.toStringAsFixed(2)} ms',
          );
        },
      );

      test(
        'Verification of a signed message performance',
        () {
          final stopwatch = Stopwatch()..start();
          sphincsPlus.verify(
            message: message,
            publicKey: publicKey,
            signedMessage: signedMessage,
          );
          stopwatch.stop();

          final elapsedTime = stopwatch.elapsed.inMicroseconds / 1000;
          print(
            'Verification of a signed message performed in ${elapsedTime.toStringAsFixed(2)} ms',
          );
        },
      );
    },
  );
}
