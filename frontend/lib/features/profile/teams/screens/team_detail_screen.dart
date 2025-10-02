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

  void _showAddPlayerDialog() {
    final playerNameController = TextEditingController();
    final playerPositionController = TextEditingController();
    final playerJerseyNumber = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Adicionar Novo Jogador'),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: playerNameController,
                  decoration: const InputDecoration(labelText: 'Nome do Jogador'),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'O nome é obrigatório.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: playerPositionController,
                  decoration: const InputDecoration(labelText: 'Posição (ex: Pivô)'),
                ),
                const SizedBox(height: 16,),
                TextFormField(
                  controller: playerJerseyNumber,
                  decoration: const InputDecoration(labelText: 'Numeração de Camisa'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'O número da camisa é obrigatório.';
                    }
                    return null;
                  },
                )
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            ElevatedButton(
              child: const Text('Adicionar'),
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  final playerProvider = context.read<PlayerProvider>();
                  try {
                    await playerProvider.addPlayerToTeam(
                      widget.teamId,
                      playerNameController.text,
                      playerPositionController.text,
                      int.parse(playerJerseyNumber.text)
                    );

                    if (mounted) {
                      Navigator.of(dialogContext).pop();
                    }
                  } catch (e) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.redAccent,
                          content: Text('Erro ao adicionar jogador: $e'),
                        ),
                      );
                    }
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }
}