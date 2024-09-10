enum Params {
  haraka_128f,
  haraka_128s,
  haraka_192f,
  haraka_192s,
  haraka_256f,
  haraka_256s,
  shake_128f,
  shake_128s,
  shake_192f,
  shake_192s,
  shake_256f,
  shake_256s,
  sha2_128f,
  sha2_128s,
  sha2_192f,
  sha2_192s,
  sha2_256f,
  sha2_256s;

  @override
  String toString() {
    super.toString();
    return 'sphincs-${name.replaceAll('_', '-')}';
  }
}
