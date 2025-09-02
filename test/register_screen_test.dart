import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo/screens/register_screen.dart';

void main() {
  group('RegisterScreen', () {
    testWidgets('affiche tous les champs et le bouton', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: RegisterScreen()));

      expect(find.text('Créer un compte'), findsWidgets);
      expect(find.byType(TextFormField), findsNWidgets(2));
      expect(find.text('Créer mon compte'), findsOneWidget);
    });

    testWidgets('valide les champs vides et affiche les erreurs', (
      tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: RegisterScreen()));

      await tester.tap(find.text('Créer mon compte'));
      await tester.pumpAndSettle();

      // Email vide
      expect(find.text('Email requis'), findsOneWidget);
      // MDP vide -> ton validator renvoie "6 caractères minimum"
      expect(find.text('6 caractères minimum'), findsOneWidget);
    });

    testWidgets('affiche erreur longueur minimale du mot de passe', (
      tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: RegisterScreen()));

      await tester.enterText(find.byType(TextFormField).at(0), 'a@b.com');
      await tester.enterText(
        find.byType(TextFormField).at(1),
        '123',
      ); // trop court
      await tester.tap(find.text('Créer mon compte'));
      await tester.pumpAndSettle();

      expect(find.text('6 caractères minimum'), findsOneWidget);
    });

    testWidgets('le lien vers connexion navigue vers /login', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const RegisterScreen(),
          routes: {
            '/login': (_) => const Scaffold(body: Text('Login Placeholder')),
          },
        ),
      );

      await tester.tap(find.text('Déjà un compte ? Se connecter'));
      await tester.pumpAndSettle();

      expect(find.text('Login Placeholder'), findsOneWidget);
    });
  });
}
