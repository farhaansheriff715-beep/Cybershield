import 'dart:convert';
import 'package:http/http.dart' as http;

class IpService {
  static Future<String> fetchPublicIP() async {
    try {
      final response = await http.get(
        Uri.parse("https://api.ipify.org?format=json"),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['ip'] ?? "Unknown IP";
      }
      return "Failed to fetch IP";
    } catch (_) {
      return "Error fetching IP";
    }
  }
}
