import 'package:flutter/material.dart';
import 'package:frontend/models/player_models.dart';
import 'package:frontend/core/services/player_service.dart';

class PlayerProvider with ChangeNotifier {
  final PlayerService _playerService;
  PlayerProvider(this._playerService);

  List<Player> _players = [];
  List<Player> get players => _players;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  Future<void> fetchPlayersForTeam(int teamId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _players = await _playerService.getPlayersForTeam(teamId);
    } catch (e) {
      _error = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addPlayerToTeam(int teamId, String name, String position, int jerseyNumber) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      await _playerService.addPlayerToTeam(teamId, name, position, jerseyNumber);
      await fetchPlayersForTeam(teamId);
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      throw e;
    }
  }
}