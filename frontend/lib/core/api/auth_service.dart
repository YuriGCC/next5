import 'package:dio/dio.dart';
import 'package:frontend/core/api/api_service.dart';

class AuthService {
  final ApiService _apiService = ApiService();

  Future<Map<String, dynamic>?> login(String email, String password) async {
    final response = await _apiService.dio.post(
      '/login',
      data: {
        'email': email,
        'password': password
      },
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
      final response = await _apiService.dio.post(
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