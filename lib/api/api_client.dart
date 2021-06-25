import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:meet_up_vor_2/constants.dart';

class Client {
  Dio init() {
    Dio _dio = new Dio();
    if (kMockApi) {
      _dio.interceptors.add(new MockInterceptor());
    }
    _dio.options.baseUrl = kBaseUrl;
    return _dio;
  }
}

class MockInterceptor extends Interceptor {
  static const _jsonDir = 'assets/json';
  static const _jsonExtension = '.json';

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final resourcePath = _jsonDir + options.path + _jsonExtension;
    final data = await rootBundle.load(resourcePath);
    final map = utf8.decode(
      data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes),
    );

    handler.resolve(Response(
      requestOptions: options,
      data: map,
      statusCode: 200,
    ));
  }
}
