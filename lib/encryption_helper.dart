import 'dart:convert';
import 'dart:typed_data';
import 'package:pointycastle/api.dart';
import 'package:pointycastle/block/aes.dart';
import 'package:pointycastle/block/aes_fast.dart';
import 'package:pointycastle/block/modes/cbc.dart';
import 'package:pointycastle/padded_block_cipher/padded_block_cipher_impl.dart';
import 'package:pointycastle/paddings/pkcs7.dart';

class Encryption {
  static final Uint8List _key = Uint8List.fromList("1122334455667788".codeUnits);

  static final Uint8List _iv = Uint8List.fromList("0000000000000000".codeUnits);

  static String encrypt(String text) {
    return base64Encode(encryptList(utf8.encode(text) as Uint8List?));
  }

  static Uint8List encryptList(Uint8List? data) {
    final CBCBlockCipher cbcCipher = CBCBlockCipher(AESEngine());
    final ParametersWithIV<KeyParameter> ivParams =
        ParametersWithIV<KeyParameter>(KeyParameter(_key), _iv);
    final PaddedBlockCipherParameters<CipherParameters?, CipherParameters?>
        paddingParams =
        PaddedBlockCipherParameters<CipherParameters?, CipherParameters?>(
            ivParams, null);

    final PaddedBlockCipherImpl paddedCipher =
        PaddedBlockCipherImpl(PKCS7Padding(), cbcCipher);
    paddedCipher.init(true, paddingParams);
    return paddedCipher.process(data);

    // try {
    // } catch (e) {
    //   print(e);
    //   return null;
    // }
  }

  static String decrypt(String data) =>
      utf8.decode(decryptList(base64Decode(data)));

  static Uint8List decryptList(Uint8List data) {
    final CBCBlockCipher cbcCipher = CBCBlockCipher(AESFastEngine());
    final ParametersWithIV<KeyParameter> ivParams =
        ParametersWithIV<KeyParameter>(KeyParameter(_key), _iv);
    final PaddedBlockCipherParameters<CipherParameters?, CipherParameters?>
        paddingParams =
        PaddedBlockCipherParameters<CipherParameters?, CipherParameters?>(
            ivParams, null);
    final PaddedBlockCipherImpl paddedCipher =
        PaddedBlockCipherImpl(PKCS7Padding(), cbcCipher);
    paddedCipher.init(false, paddingParams);
    return paddedCipher.process(data);
  }
}
