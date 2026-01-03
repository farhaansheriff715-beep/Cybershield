import 'package:encrypt/encrypt.dart' as encrypt;

class EncryptionService {
  // ✅ SAME KEY EVERY TIME
  static final _key =
  encrypt.Key.fromUtf8('12345678901234567890123456789012');
  static final _iv = encrypt.IV.fromLength(16);

  final _encrypter = encrypt.Encrypter(
    encrypt.AES(_key, mode: encrypt.AESMode.cbc),
  );

  String encryptText(String text) {
    return _encrypter.encrypt(text, iv: _iv).base64;
  }

  String decryptText(String encrypted) {
    try {
      if (encrypted == null || encrypted.isEmpty) return "";
      return _encrypter.decrypt64(encrypted, iv: _iv);
    } catch (_) {

      return "";
    }
  }
}
