import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto_keys/crypto_keys.dart';

KeyPair generatePrivateKey() {
  var keyPair = KeyPair.generateSymmetric(128);
  var keyPairGenerator = KeyPair.generateRsa();
  keyPair = keyPairGenerator;
  return keyPair;
}

String signJSONMessage(PrivateKey privateKey, String bodyData) {
  var signer = privateKey.createSigner(algorithms.signing.rsa.sha256);
  var signatureBytes = signer.sign(utf8.encode(bodyData));
  return base64.encode(signatureBytes.data);
}

bool verifyJsonMessage(String bodyData, String messageFooter, KeyPair keyPair) {
  var signer = keyPair.privateKey!.createSigner(algorithms.signing.rsa.sha256);
  var verifier =
      keyPair.publicKey!.createVerifier(algorithms.signing.rsa.sha256);
  var signature = signer.sign(messageFooter.codeUnits);
  var verified =
      verifier.verify(Uint8List.fromList(messageFooter.codeUnits), signature);
  //var verified = verifier.verify(base64.decode(messageFooter), signature);
  return verified;
}

void main(List<String> arguments) {
  KeyPair keyPair = generatePrivateKey();
  PublicKey publicKey = keyPair.publicKey!;
  PrivateKey privateKey = keyPair.privateKey!;
  print("public Key $publicKey");
  print("private Key ${privateKey.toString()}");
  String dataToEncrypt = "Hi i am Mahmoud";
  String encryptedData = signJSONMessage(privateKey, dataToEncrypt);
  print(encryptedData);
  bool isValid = verifyJsonMessage(dataToEncrypt, encryptedData, keyPair);
  print(isValid);
}
