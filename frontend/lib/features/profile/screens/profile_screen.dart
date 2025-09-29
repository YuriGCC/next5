import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/features/profile/widgets/user_item_list_widget.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() {
    return _ProfileScreenState();
  }
}

class _ProfileScreenState extends State<ProfileScreen> {

  @override
  Widget build(BuildContext context) {

    return SingleChildScrollView(
      child: Column(
        children: [
          UserItemListWidget(name: 'teste', email: 'teste@gmail.com'),
          ElevatedButton(
              onPressed: () => {_goToCredentialsForm()},
              child: const Text('alterar credenciais')
          ),
          ListTile(
            leading: const Icon(Icons.groups),
            title: const Text('Meus Times'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              _goToMyTeams();
            },
          ),
        ],
      ),
    );
  }

  void _goToMyTeams() {
    context.go('/team');
  }

  void _goToCredentialsForm() {
    // context.push('/path');
  }
}