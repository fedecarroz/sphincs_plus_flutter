import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';

import 'package:ffi/ffi.dart';
import 'package:sphincs_plus/params.dart';
import 'package:sphincs_plus/thash.dart';

import 'sphincs_plus_bindings_generated.dart';

/// Get the dynamic library in which the symbols for [SphincsPlusBindings] can be found.
DynamicLibrary _getLib(Params params, Thash thash) {
  if (Platform.isMacOS || Platform.isIOS) {
    // return DynamicLibrary.open('$params-$thash.dylib'); //? Check if possible

    return DynamicLibrary.open('$params-$thash.framework/$params-$thash');
  }
  if (Platform.isAndroid || Platform.isLinux) {
    return DynamicLibrary.open('$params-$thash.so');
  }
  if (Platform.isWindows) {
    return DynamicLibrary.open('$params-$thash.dll');
  }
  throw UnsupportedError('Unknown platform: ${Platform.operatingSystem}');
}

class SphincsPlus {
  /// Set of SPHINCS+ parameters
  final Params params;

  /// Tweakable hash
  final Thash thash;

  /// The bindings to the native functions in the dynamic library.
  late final SphincsPlusBindings _bindings;

  SphincsPlus({
    this.params = Params.shake_256f,
    this.thash = Thash.robust,
  }) {
    _bindings = SphincsPlusBindings(_getLib(params, thash));
  }

  /// Returns the length of a secret key
  int get skLength => _bindings.crypto_sign_secretkeybytes();

  /// Returns the length of a public key
  int get pkLength => _bindings.crypto_sign_publickeybytes();

  /// Returns the length of a signature
  int get signatureLength => _bindings.crypto_sign_bytes();

  /// Returns the length of the seed required to generate a key pair
  int get seedLength => _bindings.crypto_sign_seedbytes();

  /// Generates a SPHINCS+ key pair (public key, secret key)
  (Uint8List, Uint8List) generateKeyPair({String? seed}) {
    final pkPointer = calloc.allocate<UnsignedChar>(pkLength);
    final skPointer = calloc.allocate<UnsignedChar>(skLength);

    if (seed != null) {
      final seedPointer = calloc.allocate<UnsignedChar>(seedLength);
      final seedBytes = utf8.encode(seed);
      for (var i = 0; i < seedLength; i++) {
        seedPointer[i] = seedBytes[i];
      }
      _bindings.crypto_sign_seed_keypair(pkPointer, skPointer, seedPointer);
      calloc.free(seedPointer);
    } else {
      _bindings.crypto_sign_keypair(pkPointer, skPointer);
    }

    final pk = Uint8List.fromList(
      (pkPointer as Pointer<Uint8>).asTypedList(pkLength),
    );

    final sk = Uint8List.fromList(
      (skPointer as Pointer<Uint8>).asTypedList(skLength),
    );

    calloc
      ..free(pkPointer)
      ..free(skPointer);

    return (pk, sk);
  }

  /// Returns the signed message
  Uint8List sign({
    required String message,
    required Uint8List secretKey,
  }) {
    if (secretKey.length != skLength) {
      throw Exception('Invalid secret key!');
    }
    final mLength = message.length;
    final smLength = mLength + signatureLength;

    final smlen = calloc.allocate<UnsignedLongLong>(1);
    smlen.value = smLength;

    final sm = calloc.allocate<UnsignedChar>(smLength);

    final m = calloc.allocate<UnsignedChar>(mLength);
    final msgBytes = utf8.encode(message);
    for (var i = 0; i < mLength; i++) {
      m[i] = msgBytes[i];
    }

    final sk = calloc.allocate<UnsignedChar>(skLength);
    for (var i = 0; i < skLength; i++) {
      sk[i] = secretKey[i];
    }
    _bindings.crypto_sign(sm, smlen, m, mLength, sk);

    final signedMessage = Uint8List.fromList(
      (sm as Pointer<Uint8>).asTypedList(smLength),
    );

    calloc
      ..free(sm)
      ..free(smlen)
      ..free(m)
      ..free(sk);

    return signedMessage;
  }

  /// Verifies a given signed message under a given public key
  bool verify({
    required String message,
    required Uint8List signedMessage,
    required Uint8List publicKey,
  }) {
    final mLength = message.length;
    final smLength = mLength + signatureLength;
    if (signedMessage.length != smLength) {
      return false;
    }
    if (publicKey.length != pkLength) {
      throw Exception('Invalid public key!');
    }

    final mlen = calloc.allocate<UnsignedLongLong>(1);
    mlen.value = mLength;

    final m = calloc.allocate<UnsignedChar>(mLength);
    final msgBytes = utf8.encode(message);
    for (var i = 0; i < mLength; i++) {
      m[i] = msgBytes[i];
    }

    final sm = calloc.allocate<UnsignedChar>(smLength);
    for (var i = 0; i < smLength; i++) {
      sm[i] = signedMessage[i];
    }

    final pk = calloc.allocate<UnsignedChar>(pkLength);
    for (var i = 0; i < pkLength; i++) {
      pk[i] = publicKey[i];
    }

    final result = _bindings.crypto_sign_open(m, mlen, sm, smLength, pk);

    calloc
      ..free(m)
      ..free(mlen)
      ..free(sm)
      ..free(pk);

    return result == 0;
  }
}
