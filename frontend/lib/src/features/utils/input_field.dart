import 'package:flutter/material.dart';

class InputField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final Widget? suffixIcon;
  final TextInputType inputType;
  final bool isPassword;
  final String? Function(String?)? validator;

  InputField({
    super.key,
    required this.labelText,
    required this.controller,
    this.inputType = TextInputType.text,
    this.isPassword = false,
    this.validator,
    this.suffixIcon
  });


  @override
  State<InputField> createState() {
    return _InputFieldState();
  }

}

class _InputFieldState extends State<InputField> {
  bool _isObscured = true;

  @override
  Widget build(BuildContext context) {
    const Color textHighlightColor  = Color(0xFFFFC107); // Gold/Amber
    const Color primaryTextColor = Color(0xFFEAEAEA); // Soft White
    const Color backgroundInputColor = Color(0xFF8A8A8A); // Medium Gray
    const Color componentBackgroundColor = Color(0xFF1E1E1E); // Dark Gray

    return TextFormField(
      controller: widget.controller,
      keyboardType: widget.inputType,
      obscureText: widget.isPassword ? _isObscured : false,
      validator: widget.validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,

      decoration: InputDecoration(
        labelText: widget.labelText,
        labelStyle: const TextStyle(color: primaryTextColor),
        filled: true,
        fillColor: backgroundInputColor,
        suffixIcon: _buildSuffixIcon(),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide.none,
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: textHighlightColor, width: 2),
        ),

        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),

        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),

      ),
    );
  }

  Widget? _buildSuffixIcon() {
    if (widget.isPassword) {
      return IconButton(
        icon: Icon(
          _isObscured ? Icons.visibility : Icons.visibility_off
        ),
        onPressed: () {
          setState(() {
            _isObscured = !_isObscured;
          });
        },
      );
    }

    return widget.suffixIcon;
  }
}