import 'package:dio/dio.dart';
import 'package:frontend/core/services/secure_storage_service.dart';

Dio setupDio() {
  final SecureStorageService storageService = SecureStorageService();
  // 10.0.2.2 para emulador
  // ip da máquina rodandobackend para celular físico
  const String baseUrl = 'http://192.168.100.48:8000/';

  final dio = Dio(
      BaseOptions(
          baseUrl: baseUrl,
          connectTimeout: const Duration(seconds: 10),
      )
  );

  dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        print('--> [${options.method}] Enviando para: ${options.uri}');
        final publicRoutesPrefixes = ['/login', '/register'];
        final bool isPublicRoute = publicRoutesPrefixes.any((prefix) => options.path.startsWith(prefix));
        if (!isPublicRoute) {
          final token = await storageService.readToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
        }
        return handler.next(options);
      },
      onError: (e, handler) {
          print('<-- [INTERCEPTOR] ERROR: [${e.response?.statusCode}] Path: ${e.requestOptions.uri}');

          if (e.response?.data != null) {
            print('<-- [ERROR DETAIL]: ${e.response?.data}');
          }

          return handler.next(e);
      }
  ));

  return dio;
}