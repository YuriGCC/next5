import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/features/enums/nav_bar_page.dart';
import 'package:frontend/features/utils/custom_navigationbar_widget.dart';

class AppShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const AppShell({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Next5"),
      ),
      // O corpo agora é o navigationShell, que contém a tela da aba ativa.
      body: navigationShell,
      bottomNavigationBar: CustomNavBarWidget(
        currentPage: NavBarPage.values[navigationShell.currentIndex],
      ),
    );
  }
}