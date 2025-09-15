import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio;

  static const String _baseUrl = 'https://coffee.alexflipnote.dev/random.json';

  ApiService() : _dio = Dio(BaseOptions(
    baseUrl: _baseUrl,
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 3),
  )) {
  }
}