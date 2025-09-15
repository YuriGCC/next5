import 'package:flutter/material.dart';
import 'package:frontend/features/recording/screens/login_screen.dart';
import 'package:frontend/features/utils/routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginScreen(),
      initialRoute: '/',
      theme: ,
      routes: routes,
    );
  }
}