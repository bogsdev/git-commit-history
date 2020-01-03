class NotSoSafeDecryptionUtil {
  String decrypt(String key) {
    String token =
        String.fromCharCodes(key.split(",").map((c) => int.parse(c)));
    return token;
  }
}
