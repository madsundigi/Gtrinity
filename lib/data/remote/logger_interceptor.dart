import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class LoggerInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    debugPrint('--> ${options.method.toUpperCase()} ${options.baseUrl}${options.path}');
    debugPrint('Headers: ${options.headers}');
    if (options.data != null) {
      debugPrint('Body: ${options.data}');
    }
    return super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    debugPrint('<-- ${response.statusCode} ${response.requestOptions.method.toUpperCase()} ${response.requestOptions.baseUrl}${response.requestOptions.path}');
    debugPrint('Response: ${response.data}');
    return super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    debugPrint('<-- ERROR ${err.response?.statusCode} ${err.requestOptions.method.toUpperCase()} ${err.requestOptions.baseUrl}${err.requestOptions.path}');
    debugPrint('Message: ${err.message}');
    if (err.response?.data != null) {
      debugPrint('Error Body: ${err.response?.data}');
    }
    return super.onError(err, handler);
  }
}
