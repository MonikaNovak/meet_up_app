import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:meet_up_vor_2/api/models/User.dart';
import 'package:meet_up_vor_2/main.dart';

class LoginProvider {
  Dio _client;

  LoginProvider(this._client);

  Future<User?> login(String username, String password) async {
    try {
      final response = await _client
          .post('/login', data: {username: username, password: password});
      if (response.statusCode == 200) {
        return User.fromJson(json.decode(response.toString()));
      } else {
        logger.i(
            "Login failed: ${response.statusCode}/${response.statusMessage}");
        return null;
      }
    } catch (err, stack) {
      logger.e("Login failed...", err, stack);
      throw err;
    }
  }
}
