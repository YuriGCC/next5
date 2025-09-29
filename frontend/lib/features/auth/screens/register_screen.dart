import 'package:flutter/material.dart';
import 'package:frontend/features/utils/input_field.dart';
import 'package:frontend/features/auth/widgets/password_checklist.dart';
import 'package:frontend/core/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() {
    return _RegisterScreenState();
  }
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _functionController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override void dispose() {
    _emailController.dispose();
    _nameController.dispose();
    _functionController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Criar Conta'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 24),
                  InputField(labelText: 'Nome Completo', controller: _nameController),
                  const SizedBox(height: 16),
                  InputField(labelText: 'Função', controller: _functionController),
                  const SizedBox(height: 16),
                  InputField(labelText: 'Email', controller: _emailController, inputType: TextInputType.emailAddress),
                  const SizedBox(height: 16),
                  InputField(labelText: 'Senha', controller: _passwordController, isPassword: true),
                  const SizedBox(height: 16),
                  PasswordCheckList(
                      password1Controller: _passwordController,
                      password2Controller: _confirmPasswordController,
                  ),
                  const SizedBox(height: 16,),
                  InputField(labelText: 'Confirmar Senha', controller: _confirmPasswordController, isPassword: true),
                  const SizedBox(height: 48),
                  if (authProvider.isLoading) const Center(child: CircularProgressIndicator(),)
                  else ElevatedButton(
                    onPressed: _register,
                    child: const Text('cadastrar-se'),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _register() async {
    if (_formKey.currentState?.validate() ?? false) {
      final authProvider = context.read<AuthProvider>();

      final sucess = await authProvider.register(
          email: _emailController.text,
          password: _passwordController.text,
          fullName: _nameController.text
      );

      if (!sucess && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.redAccent,
            content: Text(authProvider.errorMessage ?? 'Ocorreu um erro'),
          )
        );
      }
    }
  }
}

