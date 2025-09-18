import 'package:flutter/cupertino.dart';
import 'package:frontend/features/auth/screens/login_screen.dart';
import 'package:frontend/features/auth/screens/register_screen.dart';


final Map<String, WidgetBuilder> routes = {
  '/' : (context) => const LoginScreen(),
  '/register': (context) => const RegisterScreen(),
};