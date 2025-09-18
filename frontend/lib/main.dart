import 'package:flutter/material.dart';
import 'package:frontend/src/features/utils/routes.dart';
import 'package:frontend/src/features/utils/app_theme.dart';
import 'package:frontend/src/core/auth_provider.dart';
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