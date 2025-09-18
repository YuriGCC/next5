import 'package:flutter/material.dart';
import 'package:frontend/features/utils/input_field.dart';
import 'package:frontend/core/auth_provider.dart';
import 'package:provider/provider.dart';

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

  Future<void> _login() async {
    if (_formKey.currentState?.validate() ?? false) {
      final authProvider = context.read<AuthProvider>();

      final sucess = await authProvider.login(
        _emailController.text,
        _passwordController.text
      );

      if (!sucess && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.redAccent,
            content: Text('Email ou senha inválidos. Tente novamente'),
          )
        );
      }
    }
  }

  void redirectToRegister() {
    Navigator.of(context).pushNamed('/register');
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    return Scaffold(
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
                    InputField(labelText: 'Senha', controller: _passwordController, isPassword: true,),
                    const SizedBox(height: 25,),
                    Row(
                      children: [
                        if (authProvider.isLoading)
                          const Center(
                            child: CircularProgressIndicator(
                                color: Color(0xFFFFC107)),)
                        else
                        ElevatedButton(
                            onPressed: _login,
                            child: const Text('login')),
                        const SizedBox(height: 45,),
                        TextButton(
                          child: const Text(
                            'Esqueceu a senha?',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline
                            ),
                          ),
                          onPressed: () {

                          },
                        )
                      ],
                    ),
                    ElevatedButton(
                      onPressed: redirectToRegister,
                      child: const Text('registrar-se'),
                    ),
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
