import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:pointycastle/export.dart';

class EncryptionHelper {
  var key = base64.decode('112233445566');
  var params = base64.decode('112233445566');

  void decrypt() {
    var key = base64.decode('9JYmap3xB79oyBkY6ZIdJCXaOr/CurCK8XUsRZL9XXI=');
    var params = base64.decode('BBChkSMIq/v35PRRWAJGwtTr');
    var cipherText =
        base64.decode('Dh+lg2IMzcLC0toDRSoNMAQoR7MWKMLMPRi7KtdQdmw=');
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
    print(plainishText);
  }

  void encrypt() {
    var key = Uint8List(32); // the 256 bit key
    var plainText = 'Ciao Mondo';
    var random = Random.secure();
    var params = Uint8List(18)
      ..[0] = 4
      ..[1] = 16;
    for (int i = 2; i < 18; i++) {
      params[i] = random.nextInt(256);
    }
    var iv = params.sublist(2);

    var cipher = PaddedBlockCipherImpl(
      PKCS7Padding(),
      CBCBlockCipher(AESFastEngine()),
    )..init(
        true /*encrypt*/,
        PaddedBlockCipherParameters<CipherParameters, CipherParameters>(
          ParametersWithIV<KeyParameter>(KeyParameter(key), iv),
          null,
        ),
      );

    var plainBytes =
        Uint8List.fromList(utf8.encode(base64.encode(utf8.encode(plainText))));
    var cipherText = cipher.process((plainBytes));
    print(cipherText);
  }
}
