enum Params {
  haraka_128f('haraka-128f'),
  haraka_128s('haraka-128s'),
  haraka_192f('haraka-192f'),
  haraka_192s('haraka-192s'),
  haraka_256f('haraka-256f'),
  haraka_256s('haraka-256s'),
  sha2_128f('sha2-128f'),
  sha2_128s('sha2-128s'),
  sha2_192f('sha2-192f'),
  sha2_192s('sha2-192s'),
  sha2_256f('sha2-256f'),
  sha2_256s('sha2-256s'),
  shake_128f('shake-128f'),
  shake_128s('shake-128s'),
  shake_192f('shake-192f'),
  shake_192s('shake-192s'),
  shake_256f('shake-256f'),
  shake_256s('shake-256s');

  final String headerName;

  const Params(this.headerName);

  @override
  String toString() {
    super.toString();
    return 'sphincs-$headerName';
  }
}
