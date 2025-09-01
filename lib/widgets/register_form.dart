import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'email_field.dart';
import 'password_field.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmPasswordCtrl = TextEditingController();

  bool _loading = false;
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  Future<void> _register() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    // Vérification que le mot de passe et sa confirmation correspondent
    if (_passwordCtrl.text != _confirmPasswordCtrl.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Les mots de passe ne correspondent pas")),
      );
      return;
    }

    setState(() => _loading = true);

    await Future.delayed(const Duration(seconds: 1)); // Simulation d'API

    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Inscription réussie ✅')));
    context.go('/login');
    setState(() => _loading = false);
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmPasswordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          EmailField(controller: _emailCtrl),
          const SizedBox(height: 16),
          PasswordField(
            controller: _passwordCtrl,
            obscure: _obscurePassword,
            onToggleObscure: () {
              setState(() => _obscurePassword = !_obscurePassword);
            },
          ),
          const SizedBox(height: 16),
          PasswordField(
            controller: _confirmPasswordCtrl,
            obscure: _obscureConfirm,
            onToggleObscure: () {
              setState(() => _obscureConfirm = !_obscureConfirm);
            },
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: _loading ? null : _register,
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(48),
            ),
            child: _loading
                ? const CircularProgressIndicator(strokeWidth: 2)
                : const Text("S'inscrire"),
          ),
          const SizedBox(height: 16),
          Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 4,
            children: [
              const Text('Déjà un compte ?'),
              TextButton(
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  minimumSize: const Size(0, 0),
                ),
                onPressed: () => context.go('/login'),
                child: const Text('Se connecter'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
