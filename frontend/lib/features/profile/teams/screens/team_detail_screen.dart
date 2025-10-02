import 'package:flutter/material.dart';
import 'package:frontend/core/providers/player_provider.dart';
import 'package:provider/provider.dart';
import 'package:frontend/features/profile/widgets/user_item_list_widget.dart';

class TeamDetailScreen extends StatefulWidget {
  final int teamId;
  const TeamDetailScreen({super.key, required this.teamId});

  @override
  State<TeamDetailScreen> createState() => _TeamDetailScreenState();
}

class _TeamDetailScreenState extends State<TeamDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PlayerProvider>().fetchPlayersForTeam(widget.teamId);
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Jogadores do Time')),
      body: Consumer<PlayerProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) return const Center(child: CircularProgressIndicator());
          if (provider.error != null) return Center(child: Text('Erro: ${provider.error}'));
          if (provider.players.isEmpty) return const Center(child: Text('Este time ainda não tem jogadores.'));

          return ListView.builder(
            itemCount: provider.players.length,
            itemBuilder: (context, index) {
              final player = provider.players[index];
              return ListTile(
                title: Text(player.name),
                subtitle: Text(
                    '${player.position ?? "Sem posição"}, '
                    '${player.jerseyNumber == null ? 'Sem numeração de camisa' :
                    'Camisa ${player.jerseyNumber}'}'
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddPlayerDialog,
        child: const Icon(Icons.person_add),
      ),
    );
  }

  void _showAddPlayerDialog() {}
}