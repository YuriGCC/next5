import 'package:flutter/material.dart';
import 'package:frontend/features/utils/app_router.dart';
import 'package:frontend/features/utils/app_theme.dart';
import 'package:frontend/core/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:frontend/features/utils/app_router.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => AuthProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Next5',
      theme: AppTheme.buildTheme(),
        routerConfig: appRouter
    );
  }
}