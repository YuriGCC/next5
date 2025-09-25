import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/features/utils/app_shell.dart';
import 'package:frontend/features/home/secreens/home_screen.dart';
import 'package:frontend/features/auth/screens/register_screen.dart';
import 'package:frontend/features/auth/screens/login_screen.dart';
import 'package:frontend/features/teams/screens/team_detail_screen.dart';
import 'package:frontend/features/teams/screens/team_screen.dart';


final _shellNavigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  initialLocation: '/login',
  navigatorKey: GlobalKey<NavigatorState>(),
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return AppShell(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          navigatorKey: _shellNavigatorKey,
          routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) => HomeScreen(),
            ),
          ],
        ),

        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/profile',
              builder: (context, state) => const Center(child: Text("Tela de Perfil")),
            ),
          ],
        ),

        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/video_area',
              builder: (context, state) => const Center(child: Text("Área de Vídeos")),
            ),
          ],
        ),

        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/live_game',
              builder: (context, state) => const Center(child: Text("Tela de Jogo")),
            ),
          ],
        ),

        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/teams',
              builder: (context, state) => const TeamsScreen(),
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
          ],
        ),
      ],
    ),

    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
  ],
);