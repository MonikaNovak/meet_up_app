import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:meet_up_vor_2/api/models/Token.dart';
import 'package:meet_up_vor_2/api/models/User.dart';
import 'package:meet_up_vor_2/main.dart';
import 'package:http/http.dart' as http;

class LoginProvider {
  Dio _client;

  LoginProvider(this._client);

  Future<User?> getUserLocalJson() async {
    try {
      final response = await _client.post('/login', data: {});
      if (response.statusCode == 200) {
        return User.fromJsonLocal(json.decode(response.toString()));
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

  Future<User?> getUser() async {
    try {
      final response = await _client.get('/users');
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

/*  Future<User?> getUser(token) async {
    try {
      final response = await http
          .get(Uri.parse('http://ccproject.robertdoes.it/users'), headers: {
        HttpHeaders.authorizationHeader: token,
      });
      if (response.statusCode == 200) {
        return User.fromJson(json.decode(response.toString()));
      }
    } catch (err, stack) {
      logger.e("Login failed...", err, stack);
      throw err;
    }
  }*/

  Future<Token?> getToken(String userName, String password) async {
    try {
      final response = await _client.post('/users/authenticate',
          data: {'userName': userName, 'password': password});
      if (response.statusCode == 200) {
        return Token.fromJson(json.decode(response.toString()));
      } else {
        logger.i(
            "Login failed: ${response.statusCode}/${response.statusMessage}");
        return null;
      }
    } catch (err, stack) {
      print('at catch in getToken: username: ' +
          userName +
          ', password: ' +
          password);
      logger.e("Login failed...", err, stack);
      throw err;
    }
  }

  /*Future<User?> login(String username, String password) async {
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
  }*/

  Future<Token> getTokenLocalApi() async {
    try {
      final response = await _client.post('/login', data: {});
      if (response.statusCode == 200) {
        return Token.fromJson(json.decode(response.toString()));
      } else {
        logger.i(
            "Login failed: ${response.statusCode}/${response.statusMessage}");
        return new Token(token: '123456789');
      }
    } catch (err, stack) {
      logger.e("Login failed...", err, stack);
      throw err;
    }
  }
}
