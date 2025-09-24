import 'package:flutter/material.dart';

class _PasswordCheckListState extends State<PasswordCheckList> {
  bool _hasMinLength = false;
  bool _hasUppercase = false;
  bool _hasNumber = false;
  bool _hasSpecialChar = false;
  bool _bothPasswordCoincide = false;

  @override
  void initState() {
    super.initState();
    widget.password1Controller.addListener(_validatePassword);
    widget.password2Controller.addListener(_validatePassword);

  }

  @override
  void dispose() {
    widget.password1Controller.removeListener(_validatePassword);
    widget.password2Controller.removeListener(_validatePassword);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildRequirementRow(_hasMinLength, 'Pelo menos 8 caracteres'),
        _buildRequirementRow(_hasUppercase, 'Pelo menos uma letra maiúscula (A-Z)'),
        _buildRequirementRow(_hasNumber, 'Pelo menos um número (0-9)'),
        _buildRequirementRow(_hasSpecialChar, 'Pelo menos um caractere especial (!@#\$)'),
        _buildRequirementRow(_bothPasswordCoincide, 'As senhas são iguais'),
      ],
    );
  }

  void _validatePassword() {
    final password1 = widget.password1Controller.text;
    final password2 = widget.password2Controller.text;

    setState(() {
      _hasMinLength = password1.length >= 8;
      _hasUppercase = password1.contains(RegExp(r'[A-Z]'));
      _hasNumber = password1.contains(RegExp(r'[0-9]'));
      _hasSpecialChar = password1.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

      _hasMinLength = password2.length >= 8;
      _hasUppercase = password2.contains(RegExp(r'[A-Z]'));
      _hasNumber = password2.contains(RegExp(r'[0-9]'));
      _hasSpecialChar = password2.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

      _bothPasswordCoincide = password1 == password2 &&
          password2.isNotEmpty && password1.isNotEmpty ;
    });
  }

  Widget _buildRequirementRow(bool isMet, String text) {
    final color = isMet ? Colors.green : Theme.of(context).textTheme.bodyMedium?.color;
    final icon = isMet ? Icons.check_circle : Icons.remove_circle_outline;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(color: color),
          ),
        ],
      ),
    );
  }
}

class PasswordCheckList extends StatefulWidget {
  final TextEditingController password1Controller;
  final TextEditingController password2Controller;

  const PasswordCheckList({
    super.key,
    required this.password1Controller,
    required this.password2Controller
  });

  @override
  State<PasswordCheckList> createState() {
    return _PasswordCheckListState();
  }

}