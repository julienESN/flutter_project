import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/providers/todo_provider.dart';
import 'package:todo/screens/login_screen.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });
  group('LoginScreen', () {
    testWidgets('affiche les champs et le bouton', (tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (_) => TodoProvider(),
          child: const MaterialApp(home: LoginScreen()),
        ),
      );

      expect(find.text('Connexion'), findsOneWidget);
      expect(find.byType(TextFormField), findsNWidgets(2));
      expect(find.text('Se connecter'), findsOneWidget);
    });

    testWidgets('valide les champs vides et affiche les erreurs', (
      tester,
    ) async {
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (_) => TodoProvider(),
          child: const MaterialApp(home: LoginScreen()),
        ),
      );

      await tester.tap(find.text('Se connecter'));
      await tester.pumpAndSettle();

      expect(find.text('Email requis'), findsOneWidget);
      expect(find.text('Mot de passe requis'), findsOneWidget);
    });

    testWidgets('toggle visibilité du mot de passe', (tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (_) => TodoProvider(),
          child: const MaterialApp(home: LoginScreen()),
        ),
      );

      expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);

      await tester.tap(find.byIcon(Icons.visibility_outlined));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.visibility_off_outlined), findsOneWidget);
    });

    testWidgets('saisie valide enlève les erreurs', (tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (_) => TodoProvider(),
          child: const MaterialApp(home: LoginScreen()),
        ),
      );

      await tester.enterText(find.byType(TextFormField).at(0), 'a@b.com');
      await tester.enterText(find.byType(TextFormField).at(1), '123456');
      await tester.tap(find.text('Se connecter'));
      await tester.pump();

      expect(find.text('Email requis'), findsNothing);
      expect(find.text('Mot de passe requis'), findsNothing);
      expect(find.text('Au moins 6 caractères'), findsNothing);
    });
  });
}
