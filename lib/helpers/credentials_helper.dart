import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CredentialsHelper {
  static Future<bool> isAllowed(String key) async {
    final storage = FlutterSecureStorage();
    Map<String, String> allValues = await storage.readAll();

    return allValues[key] != null;
  }
}
