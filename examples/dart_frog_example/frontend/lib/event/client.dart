import 'package:dio/dio.dart';

Dio client = _getClient();

Dio _getClient() {
  final dio = Dio();
  dio.options.baseUrl = "http://192.168.178.28:8080";
  dio.options.contentType = Headers.jsonContentType;
  dio.options.responseType = ResponseType.json;
  dio.options.validateStatus = (_) => true;
  dio.interceptors.add(LogInterceptor(responseBody: true, requestBody: true));
  return dio;
}
