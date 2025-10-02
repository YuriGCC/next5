import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:frontend/features/enums/nav_bar_page.dart';

class CustomNavBarWidget extends StatelessWidget {
  const CustomNavBarWidget({super.key, required this.currentPage});

  final NavBarPage currentPage;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: 70,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: _buildNavItems(context),
        ),
      ),
    );
  }

  List<Widget> _buildNavItems(BuildContext context) {
    const allPages = NavBarPage.values;
    final List<Widget> navItems = [];

    for (var page in allPages) {
      if (page != currentPage) {
        navItems.add(
          _buildNavItem(
            context: context,
            page: page,
            icon: _getIconForPage(page),
            label: _getLabelForPage(page),
          ),
        );
      }
    }
    return navItems;
  }

  Widget _buildNavItem({
    required BuildContext context,
    required NavBarPage page,
    required IconData icon,
    required String label,
  }) {
    return InkWell(
      onTap: () {
        context.go(_getRouteForPage(page));
      },
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.grey.shade600),
            const SizedBox(height: 4),
            Text(label, style: TextStyle(color: Colors.grey.shade700)),
          ],
        ),
      ),
    );
  }

  IconData _getIconForPage(NavBarPage page) {
    switch (page) {
      case NavBarPage.home:
        return Icons.home_rounded;
      case NavBarPage.profile:
        return Icons.person_rounded;
      case NavBarPage.videoArea:
        return Icons.video_call_rounded;
      case NavBarPage.liveGame:
        return Icons.live_tv_rounded;
    }
  }

  String _getLabelForPage(NavBarPage page) {
    switch (page) {
      case NavBarPage.home:
        return 'Início';
      case NavBarPage.profile:
        return 'Perfil';
      case NavBarPage.videoArea:
        return 'Vídeos';
      case NavBarPage.liveGame:
        return "Jogar";
    }
  }

  String _getRouteForPage(NavBarPage page) {
    switch (page) {
      case NavBarPage.home:
        return '/home';
      case NavBarPage.profile:
        return '/profile';
      case NavBarPage.videoArea:
        return '/video_area';
      case NavBarPage.liveGame:
        return '/live_game';
    }
  }
}
