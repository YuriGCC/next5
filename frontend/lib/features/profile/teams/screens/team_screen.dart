import 'package:flutter/material.dart';
import 'package:frontend/core/providers/team_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:frontend/models/team_models.dart';

class TeamsScreen extends StatefulWidget {
  const TeamsScreen({super.key});

  @override
  State<TeamsScreen> createState() => _TeamsScreenState();
}

class _TeamsScreenState extends State<TeamsScreen> {
  final _teamNameController = TextEditingController();
  List<Team> _filteredTeams = [];

  @override
  void initState() {
    super.initState();

    _teamNameController.addListener(_onSearchChanged);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TeamProvider>().fetchMyTeams();
    });
  }

  @override
  void dispose() {
    _teamNameController.removeListener(_onSearchChanged);
    _teamNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Meus Times')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _teamNameController,
                  decoration: InputDecoration(
                    hintText: 'Pesquisar time',
                    suffixIcon: Icon(Icons.search),
                  ),
                ),
              ),
              SizedBox(width: 8,),
              FloatingActionButton.extended(
                onPressed: _goCreateTeam,
                icon: const Icon(Icons.add),
                label: const Text('Criar time'),
              ),
            ],
          ),
          const SizedBox(height: 16,),
            Expanded(
              child: Consumer<TeamProvider>(
                builder: (context, provider, child) {
                  if(_teamNameController.text.isEmpty) {
                    _filteredTeams = provider.teams;
                  } else {
                    _filteredTeams = provider.teams.where((team) {
                      return team.name.toLowerCase().contains(_teamNameController.text.toLowerCase());
                    }).toList();
                  }

                  if (provider.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (provider.error != null) {
                    return Center(child: Text('Erro: ${provider.error}'));
                  }
                  if (provider.teams.isEmpty) {
                    return const Center(child: Text('Você ainda não tem times.'));
                  }

                  return ListView.builder(
                    itemCount: _filteredTeams.length,
                    itemBuilder: (context, index) {
                      final team = _filteredTeams[index];
                      return ListTile(
                        title: Text(team.name),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () => context.go('/team/${team.id}'),
                      );
                    },
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  void _goCreateTeam() {
    context.push('/create_team');
  }

  void _onSearchChanged() {
    _searchTeam(_teamNameController.text);
  }

  void _searchTeam(String teamName) {
    final allTeams = context.read<TeamProvider>().teams;

    if (teamName.isEmpty) {
      setState(() {
        _filteredTeams = allTeams;
      });
    } else {
      setState(() {
        _filteredTeams = allTeams.where((team) {
          return team.name.toLowerCase().contains(teamName.toLowerCase());
        }).toList();
      });
    }

  }
}
