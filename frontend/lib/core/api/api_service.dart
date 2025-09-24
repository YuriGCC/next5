import 'package:dio/dio.dart';
import 'package:frontend/core/services/secure_storage_service.dart';

class ApiService {
  final Dio dio;
  final SecureStorageService _storageService = SecureStorageService();

  // http://10.0.2.2:8000/  emulador
  // http://127.0.0.1:8000/  web
  static const String _baseUrl = 'http://127.0.0.1:8000/';

  ApiService() : dio = Dio(BaseOptions(baseUrl: _baseUrl)) {
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        if (!options.path.contains('/auth')) {
          final token = await _storageService.readToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
        }
        return handler.next(options);
      }
    ));
  }
}