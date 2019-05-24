import 'dart:convert';
import 'package:hex/hex.dart';
import 'package:crypto/crypto.dart';

class Common {
  static Map<String, String> cookies = {};

  static void storageSet(String key, String value) {
    if (value == null)
      cookies.remove(key);
    else
      cookies[key] = value;
  }

  static String storageGet(String key) {
    return cookies[key];
  }

  static bool equalsIgnoreCase(String string1, String string2) {
    return string1?.toLowerCase() == string2?.toLowerCase();
  }

  static String toJson(dynamic object) {
    var encoder = new JsonEncoder.withIndent("     ");
    return encoder.convert(object);
  }

  static dynamic fromJson(String jsonString) {
    return json.decode(jsonString);
  }

  static bool hasKeyIgnoreCase(Map map, String key) {
    return map.keys.any((x) => equalsIgnoreCase(x, key));
  }

  static String toHexString(List data) {
    return HEX.encode(data);
  }

  static List fromHexString(String hexString) {
    return HEX.decode(hexString);
  }

  static String hashStringSHA256(String input) {
    var bytes = utf8.encode(input);
    var digest = sha256.convert(bytes);
    return toHexString(digest.bytes);
  }
}
