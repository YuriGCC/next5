import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend/core/auth_provider.dart';
import 'package:frontend/features/auth/screens/login_screen.dart';
import 'package:frontend/features/recording/screens/recording_screen.dart';


class AuthWrapper extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    if (authProvider.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (authProvider.isAuthenticated) {
      return RecordingScreen();
    } else {
      return const LoginScreen();
    }


  }
}