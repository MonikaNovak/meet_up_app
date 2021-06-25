import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:meet_up_vor_2/api/models/Message.dart';
import 'package:meet_up_vor_2/main.dart';

class MessageProvider {
  Dio _client;

  MessageProvider(this._client);

  Future<Message?> chat(int messid) async {
    try {
      final response = await _client.post('/chat', data: {messid: messid});
      if (response.statusCode == 200) {
        return Message.fromJson(json.decode(response.toString()));
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
