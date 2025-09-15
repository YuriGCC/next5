import 'package:flutter/material.dart';
import 'package:frontend/features/utils/input_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() {
    return _LoginScreenState();
  }

}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Processando login...')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const backgroundColor = const Color(0xFF1E1E1E);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    

                    const SizedBox(height: 48,),
                    InputField(
                      controller: _emailController,
                      labelText: 'Email',
                      suffixIcon: Icon(Icons.email_outlined),
                    ),
                    const SizedBox(height: 25,),
                    InputField(labelText: 'Senha', controller: _passwordController, isPassword: true,)

                  ],
                ),
              ),
            )
          ),
        ),
      ),
    );
  }

}
