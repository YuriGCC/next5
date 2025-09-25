import 'package:dio/dio.dart';
import 'package:frontend/models/team_models.dart';

class TeamService {
  final Dio _dio;
  TeamService(this._dio);

  Future<List<Team>> getMyTeams() async {
    final response = await _dio.get('/auth/teams/');
    final List<dynamic> data = response.data;
    return data.map((json) => Team.fromJson(json)).toList();
  }

  Future<Team> createTeam(String name) async {
    final response = await _dio.post(
      '/auth/teams/',
      data: {'name': name},
    );
    return Team.fromJson(response.data);
  }
}