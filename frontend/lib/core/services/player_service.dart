import 'package:dio/dio.dart';
import 'package:frontend/models/player_models.dart';

class PlayerService {
  final Dio _dio;
  PlayerService(this._dio);

  Future<List<Player>> getPlayersForTeam(int teamId) async {
    final response = await _dio.get('/team/$teamId/players/');
    final List<dynamic> data = response.data;
    return data.map((json) => Player.fromJson(json)).toList();
  }

  Future<Player> addPlayerToTeam(int teamId, String name, String? position) async {
    final response = await _dio.post(
      '/team/$teamId/players/',
      data: {'name': name, 'position': position},
    );
    return Player.fromJson(response.data);
  }
}