import 'package:flutter/material.dart';
import 'package:frontend/features/utils/routes.dart';
import 'package:frontend/features/utils/app_theme.dart';

void main() {
  runApp(const MyApp());
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