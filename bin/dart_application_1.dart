

import 'dart:convert';

import 'package:pointycastle/export.dart';

void main(List<String> arguments) {

  var key = base64.decode('9JYmap3xB79oyBkY6ZIdJCXaOr/CurCK8XUsRZL9XXI=');
  var params = base64.decode('BBChkSMIq/v35PRRWAJGwtTr');
  var cipherText =
      base64.decode('+GE+T3cfLxjfBAEBrit5YA==');
  var iv = params.sublist(2); // strip the 4, 16 DER header


  var cipher = PaddedBlockCipherImpl(
    PKCS7Padding(),
    CBCBlockCipher(AESFastEngine()),
  );

  cipher.init(
    false /*decrypt*/,
    PaddedBlockCipherParameters<CipherParameters, CipherParameters>(
      ParametersWithIV<KeyParameter>(KeyParameter(key), iv),
      null,
    ),
  );

  var plainishText = cipher.process(cipherText);

  print(utf8.decode(base64.decode(utf8.decode(plainishText))));
}
