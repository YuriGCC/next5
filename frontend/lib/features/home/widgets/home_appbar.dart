import 'package:flutter/material.dart';
import 'package:frontend/core/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class HomeAppBar extends StatefulWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  State<StatefulWidget> createState() {
    return _HomeAppBarState();
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

}

class _HomeAppBarState extends State<HomeAppBar> {
  @override
  Widget build(BuildContext context) {
    final authProvider = context.read<AuthProvider>();
    final user = authProvider.currentUser;

    return AppBar(
      title: Text('Olá ${user?.fullName ?? 'Jogador'}!'),
      actions: [
        IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () {
            context.read<AuthProvider>().logout();
          },
        ),
      ],
    );
  }

}