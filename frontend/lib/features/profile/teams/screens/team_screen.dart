import 'package:flutter/material.dart';
import 'package:frontend/core/providers/team_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class TeamsScreen extends StatefulWidget {
  const TeamsScreen({super.key});

  @override
  State<TeamsScreen> createState() => _TeamsScreenState();
}

class _TeamsScreenState extends State<TeamsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TeamProvider>().fetchMyTeams();
    });
  }

  void _showCreateTeamDialog() {
    // ... (o código do dialog é o mesmo da resposta anterior)
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Meus Times')),
      body: Consumer<TeamProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) return const Center(child: CircularProgressIndicator());
          if (provider.error != null) return Center(child: Text('Erro: ${provider.error}'));
          if (provider.teams.isEmpty) return const Center(child: Text('Você ainda não tem times.'));

          return ListView.builder(
            itemCount: provider.teams.length,
            itemBuilder: (context, index) {
              final team = provider.teams[index];
              return ListTile(
                title: Text(team.name),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () => context.go('/teams/${team.id}'),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreateTeamDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}