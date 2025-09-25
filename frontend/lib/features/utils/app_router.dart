import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/features/utils/app_shell.dart';
import 'package:frontend/features/home/secreens/home_screen.dart';
import 'package:frontend/features/auth/screens/register_screen.dart';
import 'package:frontend/features/auth/screens/login_screen.dart';
import 'package:frontend/features/profile/teams/screens/team_detail_screen.dart';
import 'package:frontend/features/profile/teams/screens/team_screen.dart';
import 'package:frontend/features/profile/screens/profile_screen.dart';
import 'package:frontend/features/live_game/screens/live_game_screen.dart';
import 'package:frontend/features/video_area/screens/video_area_screen.dart';


final _shellNavigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  initialLocation: '/home',
  navigatorKey: GlobalKey<NavigatorState>(),
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return AppShell(navigationShell: navigationShell);
      },
      branches: [
        // Branch 0
        StatefulShellBranch(
          navigatorKey: _shellNavigatorKey,
          routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) => HomeScreen(),
            ),
          ],
        ),

        // Branch 1
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/profile',
              builder: (context, state) => ProfileScreen(),
            ),
          ],
        ),

        // Branch 2
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/video_area',
              builder: (context, state) => VideoAreaScreen(),
            ),
          ],
        ),

        // Branch 3
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/live_game',
              builder: (context, state) => LiveGameScreen(),
            ),
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
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
  ],
);