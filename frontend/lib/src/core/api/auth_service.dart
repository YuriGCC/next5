import 'package:dio/dio.dart';
import 'package:frontend/src/core/api/api_service.dart';

class AuthService {
  final ApiService _apiService = ApiService();

  Future<Map<String, dynamic>?> login(String email, String password) async {
    final response = await _apiService.dio.post(
      'auth/login',
      data: FormData.fromMap({
        'email': email,
        'password': password
      }),
    );

    if (response.statusCode == 200) {
      return response.data;
    }
    return null;
  }
}