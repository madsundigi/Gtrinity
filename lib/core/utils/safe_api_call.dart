import 'package:dio/dio.dart';

Future<T> safeApiCall<T>(
  Future<Response> Function() request,
  T Function(dynamic data) fromJson,
) async {
  try {
    final response = await request();
    return fromJson(response.data);
  } on DioException catch (e) {
    if (e.type == DioExceptionType.badResponse && e.response?.data != null) {
      final data = e.response?.data;
      if (data is Map<String, dynamic> && data.containsKey('message')) {
        throw data['message'].toString();
      }
    }
    throw _handleDioError(e);
  } catch (e) {
    throw 'Unexpected error: $e';
  }
}

String _handleDioError(DioException error) {
  switch (error.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
      return "Timeout error";
    case DioExceptionType.badResponse:
      if (error.response?.statusCode == 401) {
        return "Unauthorized: Please check your credentials";
      }
      return "Server error: ${error.response?.statusCode}";
    case DioExceptionType.connectionError:
      return "No internet connection";
    case DioExceptionType.cancel:
      return "Request cancelled";
    default:
      return "Something went wrong";
  }
}
