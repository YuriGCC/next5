import 'package:dio/dio.dart';

class AuthService {
  final Dio _dio;

  AuthService(this._dio);

  Future<Map<String, dynamic>?> login(String email, String password) async {
    final response = await _dio.post(
      '/login',
      data: {'email': email, 'password': password},
    );

    if (response.statusCode == 200) {
      return response.data;
    }
    return null;
  }

  Future<Map<String, dynamic>?> register({
    required String email,
    required String fullName,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
          '/register',
          data: {
            'email': email,
            'full_name': fullName,
            'password': password,
          },
      );

      if (response.statusCode == 201) {
        return response.data;
      }
      return null;
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        throw Exception('Este email já está cadastrado.');
      }
      throw Exception('Ocorreu um erro ao tentar registrar.');
    }
  }
}