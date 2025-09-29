import 'package:flutter/material.dart';
import 'package:frontend/core/services/secure_storage_service.dart';
import 'package:frontend/features/utils/app_router.dart';
import 'package:frontend/features/utils/app_theme.dart';
import 'package:frontend/core/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';
import 'package:frontend/core/api/api_service.dart';
import 'package:frontend/core/api/auth_service.dart';
import 'package:frontend/core/services/team_service.dart';
import 'package:frontend/core/services/player_service.dart';
import 'package:frontend/core/providers/team_provider.dart';
import 'package:frontend/core/providers/player_provider.dart';


void main() {
  runApp(
    MultiProvider(
      providers: [
        // Basic dependencies

        Provider<Dio>(
          create: (_) => setupDio(),
        ),

        Provider<SecureStorageService>(
            create: (_) => SecureStorageService()
        ),

        // Services

        Provider<AuthService>(
          create: (context) => AuthService(context.read<Dio>()),
        ),

        Provider<TeamService>(create: (context) => TeamService(context.read<Dio>())),
        Provider<PlayerService>(create: (context) => PlayerService(context.read<Dio>())),

        // Providers

        ChangeNotifierProvider<AuthProvider>(
          create: (context) => AuthProvider(
            context.read<AuthService>(),
            context.read<SecureStorageService>(),
          ),
        ),

        ChangeNotifierProvider<TeamProvider>(
          create: (context) => TeamProvider(context.read<TeamService>()),
        ),
        ChangeNotifierProvider<PlayerProvider>(
          create: (context) => PlayerProvider(context.read<PlayerService>()),
        ),

      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final appRouterConfig = AppRouter(authProvider).router;

    return MaterialApp.router(
      title: 'Next5',
      theme: AppTheme.buildTheme(),
      routerConfig: appRouterConfig,
    );
  }
}