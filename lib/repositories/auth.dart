import 'dart:convert';

import 'package:bloggo_app/models/user.dart';
import 'package:http/http.dart' as http;

class AuthRepository {
  final address = "https://jsonplaceholder.typicode.com";

  Future<User?> login(String email, String password) async {
    // Simulate a network request
    try {
      final url = Uri.parse("$address/users");
      print("Fetching users from $url");

      final response = await http.get(url);
      print("Response status: ${response.statusCode}");
      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body);
        final users = body.map((dynamic item) => User.fromJson(item)).toList();

        // Find the user with the given email
        final user =
            users.firstWhere((user) => user.email.toLowerCase() == email);

        return user;
      } else {
        throw Exception('User not found');
      }
    } catch (e) {
      throw Exception('User not found');
    }
  }
}
