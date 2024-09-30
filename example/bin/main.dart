import 'dart:typed_data';

import 'package:sphincs_plus/sphincs_plus_dart.dart';

void main() {
  final sphincsPlus = SphincsPlus();

  print('Selected configuration: ${sphincsPlus.params}');

  print('Public key length: ${sphincsPlus.pkLength}');
  print('Secret key length: ${sphincsPlus.skLength}');
  print('Seed length: ${sphincsPlus.seedLength}');
  print('Signature length: ${sphincsPlus.signatureLength}');

  final Uint8List publicKey, secretKey;
  (publicKey, secretKey) = sphincsPlus.generateKeyPair(
    seed: 'a' * sphincsPlus.seedLength,
  );
  print('Public key [0..10]: ${publicKey.sublist(0, 10)}');
  print('Secret key [0..10]: ${secretKey.sublist(0, 10)}');

  const String message = 'SPHINCS+ for dart';
  final Uint8List signedMessage = sphincsPlus.sign(
    message: message,
    secretKey: secretKey,
  );
  print('Signed message [0..10]: ${signedMessage.sublist(0, 10)}');

  final bool result1 = sphincsPlus.verify(
    message: message,
    signedMessage: signedMessage,
    publicKey: publicKey,
  );
  result1
      ? print('The signature is valid.')
      : print('The signature is not valid!');

  final tamperedMessage = Uint8List.fromList(
    signedMessage.map((e) => 12).toList(),
  );

  print('Tampered message [0..10]: ${tamperedMessage.sublist(0, 10)}');

  final bool result2 = sphincsPlus.verify(
    message: message,
    signedMessage: tamperedMessage,
    publicKey: publicKey,
  );
  result2
      ? print('The tampered signature is valid.')
      : print('The tampered signature is not valid!');
}
