import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart';

String extractPayload(String payload) {
  String strPwd = "SuperSecretKey";
  String strIv = '000000000000000';
  var iv = sha256
      .convert(utf8.encode(strIv))
      .toString()
      .substring(0, 16); // Consider the first 16 bytes of all 64 bytes
  var key = sha256
      .convert(utf8.encode(strPwd))
      .toString()
      .substring(0, 32); // Consider the first 32 bytes of all 64 bytes
  IV ivObj = IV.fromUtf8(iv);
  Key keyObj = Key.fromUtf8(key);
  final encrypter = Encrypter(AES(keyObj, mode: AESMode.cbc)); // Apply CBC mode
  String firstBase64Decoding =
      String.fromCharCodes(base64.decode(payload)); // First Base64 decoding
  final decrypted = encrypter.decrypt(Encrypted.fromBase64(firstBase64Decoding),
      iv: ivObj); // Second Base64 decoding (during decryption)
  return decrypted;
}

String encrypt(String plainText) {
  String strPwd = "SuperSecretKey";
  String strIv = '0000000000000000';
  var iv = sha256.convert(utf8.encode(strIv)).toString().substring(0, 16);
  var key = sha256.convert(utf8.encode(strPwd)).toString().substring(0, 32);
  IV ivObj = IV.fromUtf8(iv);
  Key keyObj = Key.fromUtf8(key);
  final encrypter = Encrypter(AES(keyObj, mode: AESMode.cbc));
  final encrypted = encrypter.encrypt(plainText, iv: ivObj);
  return base64.encode(utf8.encode(encrypted.base64));
}

void main(List<String> args) {
  //String encrypted = encrypt("MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAkWM2o7JWXURXG4JyN+mijThZvZL//KEXq/aO7WLDURPDakskVGfCH58Wv16CLpaWryu25y0W+TvFdq512e9hidaUXKoML24K53igxxJhy68d417M60b3/1XaQM5Jm6/m668fAd2+fSPSR5YTPGo8lnk8z0V1HX3EhCFES7Ysbllcz2R74SkXqlOSPX0Poy627EmRso/dBcKuT3kj09CsSWZ0rvo79v1yAhXBGNndXhxr925bAk9jrgwipGb2qEliVZzbANH0licvrLx1RC0a7+lcz2hEJxUDOvllCSzv+2FcpDEbZqgCKN8i3M1gvXWme6kvyWm94LplhvF6N4JcawIDAQAB");
  //print(encrypted);
  String plaintext = extractPayload("cy81VGloNGFMYTVtT2R3MCtWTTUraG1vQWc1Y0FDTUpFM3Mxa3llYVNaMmsrWmNKMmlFVXRKZGdPMm9yUHN6TVg3SHFid2ltZEd3YWdSRi9OdG50SUQxTEVDMWREMy9qZjludE56aU5MVWlRVktOZlJLaGlWM1Z0bUZqVkx5SEx1SWlORjNMWUYwSEhMbm9GRSsvakNXcEZLaTRtaVZjNS9pSzI4eVRpTGRnM2ZpTjB6V2ViaTBsd0s5NFlmYXRMakVadjJWS0ttVGI5Q2RxVG5KMVR3ekg4djJST0F6T2RMUVNJTmtjMXZEZnB6ZTN5VG5vUHRjeTNzMUtoeGw1ZHdtNWVFRGdqMzIrZ05ZNmJKSzhjc05yQkhmTkxkSTRYMWsvR3lIRnZ4ekhtQTJTeHRhMmVoSnh4eWZUSHBmZ1J5dnc3ZXlzaDgxclYxdXQwVUppZG8rQ2tMN0dRdFhZMkZtRkdTT3YxeEphS2k3eTYyWEZjMXljZUVEZUVjdnpSeUtRMy9tNWJDWVJsamFzd3J4WGtLMDdYN1oyZTVWMzF6cThiVSthVzJqWXQ3aWF3TkhFd001R29zQ1lVdGU0MEQvV0JJVE5xeXdrblpTbkN6MWN6VTV4Z1pva0xEQnVaMFZ5SFFCSjVMcUxORmc4cUlZNU0yK0lWNFUrQTlvR3AwR1dtT3BXV1F1aFpDNDlBOWNuT2RBPT0=");
  print(plaintext); // This is a Test!
}
