import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/core/providers/auth_provider.dart';
import 'package:frontend/features/utils/app_shell.dart';
import 'package:frontend/features/home/secreens/home_screen.dart';
import 'package:frontend/features/auth/screens/register_screen.dart';
import 'package:frontend/features/auth/screens/login_screen.dart';
import 'package:frontend/features/profile/teams/screens/team_detail_screen.dart';
import 'package:frontend/features/profile/teams/screens/team_screen.dart';
import 'package:frontend/features/profile/screens/profile_screen.dart';
import 'package:frontend/features/live_game/screens/live_game_screen.dart';
import 'package:frontend/features/video_area/screens/video_area_screen.dart';
import 'package:frontend/features/video_area/screens/edit_video_screen.dart';

class AppRouter {
  final AuthProvider authProvider;

  AppRouter(this.authProvider);

  late final GoRouter router = GoRouter(
    initialLocation: '/home',

    navigatorKey: GlobalKey<NavigatorState>(),

    refreshListenable: authProvider,

    redirect: (BuildContext context, GoRouterState state) {
      final bool isAuthenticated = authProvider.isAuthenticated;

      if (authProvider.isLoading) return null;

      final bool isAuthRoute = state.matchedLocation == '/login' || state.matchedLocation == '/register';

      //if (!isAuthenticated && !isAuthRoute) {
      //  // return '/login';
      //  return '/video_area';
      //}

      if (isAuthenticated && isAuthRoute) {
        return '/home';
      }

      return null;
    },

    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return AppShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(path: '/home', builder: (context, state) => HomeScreen()),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(path: '/profile', builder: (context, state) => ProfileScreen()),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(path: '/video_area', builder: (context, state) => VideoAreaScreen()),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(path: '/live_game', builder: (context, state) => LiveGameScreen()),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/team',
        builder: (context, state) => TeamsScreen(),
        routes: [
          GoRoute(
            path: ':teamId',
            builder: (context, state) {
              final teamId = int.parse(state.pathParameters['teamId']!);
              return TeamDetailScreen(teamId: teamId);
            },
          ),
        ],
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/edit',
        builder: (context, state) {
          final Map<String, dynamic> data = state.extra as Map<String, dynamic>;
          final String path = data['path'];
          final bool isNetwork = data['isNetwork'];

          return EditVideoScreen(path: path, isNetwork: isNetwork);
        }
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
    ],
  );
}