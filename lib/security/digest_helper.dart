import 'dart:typed_data';

abstract class DigestHelper
{
  static bool isEqual(Uint8List digesta, Uint8List digestb) {
    if (digesta == digestb) {
      return true;
    }
    int lenA = digesta.length;
    int lenB = digestb.length;
    if (lenB == 0) {
      return lenA == 0;
    }
    int result = 0;
    result |= lenA - lenB;
    for (int i = 0; i < lenA; ++i) {
      // TODO The unsigned shift right (>>>) doesn't work as Java.
      int indexB = (i - lenB >>> 31) * i;
      result |= digesta[i] ^ digestb[indexB];
    }
    return result == 0;
  }
}