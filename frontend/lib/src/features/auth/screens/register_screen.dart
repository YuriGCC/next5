import 'package:flutter/material.dart';
import 'package:frontend/src/features/utils/input_field.dart';
import 'package:frontend/src/features/utils/input_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() {
    return _RegisterScreenState();
  }
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _functionController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> registry() async {
    if (_formKey.currentState?.validate() ?? false) {
      // Se for válido, prossiga com a lógica de registro
      print("Formulário de registro válido!");
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  InputField(labelText: 'Função dentro de jogo', controller: _functionController),
                  const SizedBox(height: 16),
                  InputField(labelText: 'Email', controller: _emailController, inputType: TextInputType.emailAddress),
                  const SizedBox(height: 16),
                  InputField(labelText: 'Senha', controller: _passwordController, isPassword: true),
                  const SizedBox(height: 16),
                  InputField(labelText: 'Confirmar Senha', controller: _confirmPasswordController, isPassword: true),
                  const SizedBox(height: 48),
                  ElevatedButton(
                    onPressed: registry,
                    child: const Text('registrar-se'),
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
}

