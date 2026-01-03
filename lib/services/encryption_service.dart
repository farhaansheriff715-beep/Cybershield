import 'dart:convert';

class EncryptionService {
  static const _key = "CYBER_SHIELD_SECRET_KEY";

  String encryptText(String text) {
    final bytes = utf8.encode(text + _key);
    return base64Encode(bytes);
  }

  String decryptText(String encrypted) {
    try {
      final decoded = utf8.decode(base64Decode(encrypted));
      return decoded.replaceAll(_key, "");
    } catch (_) {
      return "";
    }
  }
}
