import 'package:flutter/material.dart';

class PasswordField extends StatelessWidget {
  final TextEditingController controller;
  final bool obscure;
  final VoidCallback onToggleObscure;

  const PasswordField({
    super.key,
    required this.controller,
    required this.obscure,
    required this.onToggleObscure,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        labelText: 'Mot de passe',
        border: const OutlineInputBorder(),
        suffixIcon: IconButton(
          icon: Icon(
            obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
          ),
          onPressed: onToggleObscure,
        ),
      ),
      validator: (v) {
        if (v == null || v.isEmpty) return 'Mot de passe requis';
        if (v.length < 6) return 'Au moins 6 caractères';
        return null;
      },
    );
  }
}