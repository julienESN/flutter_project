import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo/screens/login_screen.dart';

void main() {
  group('LoginScreen', () {
    testWidgets('affiche les champs et le bouton', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: LoginScreen()));

      // Titre peut apparaître 2 fois (AppBar + body)
      expect(find.text('Connexion'), findsWidgets);
      expect(find.byType(TextFormField), findsNWidgets(2)); // email + mdp
      expect(find.text('Se connecter'), findsOneWidget);
    });

    testWidgets('valide les champs vides et affiche les erreurs', (
      tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: LoginScreen()));

      await tester.tap(find.text('Se connecter'));
      await tester.pumpAndSettle();

      expect(find.text('Email requis'), findsOneWidget);
      expect(find.text('Mot de passe requis'), findsOneWidget);
    });

    testWidgets('le lien vers inscription navigue vers /register', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const LoginScreen(),
          routes: {
            '/register': (_) =>
                const Scaffold(body: Text('Register Placeholder')),
          },
        ),
      );

      await tester.tap(find.text("Pas de compte ? S'inscrire"));
      await tester.pumpAndSettle();

      expect(find.text('Register Placeholder'), findsOneWidget);
    });
  });
}
