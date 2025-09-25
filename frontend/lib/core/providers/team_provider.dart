import 'package:flutter/material.dart';
import 'package:frontend/models/team_models.dart';
import 'package:frontend/core/services/team_service.dart';

class TeamProvider with ChangeNotifier {
  final TeamService _teamService;
  TeamProvider(this._teamService);

  List<Team> teams = [];
  bool isLoading = false;
  String? error;

  Future<void> fetchMyTeams() async {
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      teams = await _teamService.getMyTeams();
    } catch (e) {
      error = e.toString();
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> createTeam(String name) async {
    try {
      await _teamService.createTeam(name);
      await fetchMyTeams();
    } catch (e) {
      error = e.toString();
      notifyListeners();
    }
  }
}