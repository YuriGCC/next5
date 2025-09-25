import 'package:dio/dio.dart';
import 'package:frontend/core/services/secure_storage_service.dart';

Dio setupDio() {
  final SecureStorageService storageService = SecureStorageService();
  // 10.0.2.2 para emulador
  const String baseUrl = 'http://127.0.0.1:8000/';

  final dio = Dio(BaseOptions(baseUrl: baseUrl));

  dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final publicRoutes = ['/login', '/register'];

        if (!publicRoutes.contains(options.path)) {
          final token = await storageService.readToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
        }
        return handler.next(options);
      }
  ));

  return dio;
}