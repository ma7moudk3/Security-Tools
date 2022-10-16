import 'encryption_helper.dart';

void main(List<String> args) {
  String key = "1122334455667788";
  String encryptedText = Encryption.encrypt(key: key, text: "Hi Mahmoud");
  print(encryptedText);
  print(Encryption.decrypt(key: key, data: encryptedText));
}
