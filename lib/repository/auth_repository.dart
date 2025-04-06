import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthRepository {
  Future<Map<String, dynamic>> login(String username, String password) async {
    final url = Uri.parse('https://akgecerp.edumarshal.com/Token');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: 'grant_type=password&username=$username&password=$password',
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to login: ${response.body}');
    }
  }
}
