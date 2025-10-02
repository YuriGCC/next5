import 'package:flutter/material.dart';
import 'package:frontend/models/player_models.dart';
import 'package:frontend/core/services/player_service.dart';

class PlayerProvider with ChangeNotifier {
  final PlayerService _playerService;
  PlayerProvider(this._playerService);

  List<Player> players = [];
  bool isLoading = false;
  String? error;

  Future<void> fetchPlayersForTeam(int teamId) async {
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      players = await _playerService.getPlayersForTeam(teamId);
    } catch (e) {
      error = e.toString();
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> addPlayerToTeam(int teamId, String name, String? position, int jerseyNumber) async {
    try {
      await _playerService.addPlayerToTeam(teamId, name, position, jerseyNumber);
      await fetchPlayersForTeam(teamId);
    } catch (e) {
      error = e.toString();
      notifyListeners();
    }
  }
}