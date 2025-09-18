import 'package:flutter/material.dart';
import 'package:frontend/features/utils/routes.dart';
import 'package:frontend/features/utils/app_theme.dart';
import 'package:frontend/core/auth_provider.dart';
import 'package:provider/provider.dart';

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
      initialRoute: '/',
      theme: AppTheme.buildTheme(),
      routes: routes,
    );
  }
}