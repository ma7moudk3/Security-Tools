// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'dart:typed_data';
import 'package:pointycastle/api.dart';
import 'package:pointycastle/block/aes.dart';
import 'package:pointycastle/block/aes_fast.dart';
import 'package:pointycastle/block/modes/cbc.dart';
import 'package:pointycastle/padded_block_cipher/padded_block_cipher_impl.dart';
import 'package:pointycastle/paddings/pkcs7.dart';

class Encryption {
  static final Uint8List _iv = Uint8List.fromList("0000000000000000".codeUnits);

  static String encrypt({required String text,required String key}) {
    return base64Encode(encryptList(
        data: utf8.encode(text) as Uint8List?,
        key: Uint8List.fromList(key.codeUnits)));
  }

  static Uint8List encryptList(
      {required Uint8List? data, required Uint8List key}) {
    final CBCBlockCipher cbcCipher = CBCBlockCipher(AESEngine());
    final ParametersWithIV<KeyParameter> ivParams =
        ParametersWithIV<KeyParameter>(KeyParameter(key), _iv);
    final PaddedBlockCipherParameters<CipherParameters?, CipherParameters?>
        paddingParams =
        PaddedBlockCipherParameters<CipherParameters?, CipherParameters?>(
            ivParams, null);

    final PaddedBlockCipherImpl paddedCipher =
        PaddedBlockCipherImpl(PKCS7Padding(), cbcCipher);
    paddedCipher.init(true, paddingParams);
    return paddedCipher.process(data);
  }

  static String decrypt({required String data, required String key}) {
    return utf8.decode(decryptList(
        data: base64Decode(data), key: Uint8List.fromList(key.codeUnits)));
  }

  static Uint8List decryptList(
      {required Uint8List data, required Uint8List key}) {
    final CBCBlockCipher cbcCipher = CBCBlockCipher(AESFastEngine());
    final ParametersWithIV<KeyParameter> ivParams =
        ParametersWithIV<KeyParameter>(KeyParameter(key), _iv);
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
