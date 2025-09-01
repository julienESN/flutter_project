import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/providers/todo_provider.dart';
import 'package:todo/screens/register_screen.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('RegisterScreen', () {
    testWidgets('affiche tous les champs et le bouton', (tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (_) => TodoProvider(),
          child: MaterialApp(home: RegisterScreen()),
        ),
      );

      expect(find.text('Créer un compte'), findsOneWidget);
      expect(
        find.byType(TextFormField),
        findsNWidgets(3),
      ); // email + mdp + confirmer
      expect(find.text("S'inscrire"), findsOneWidget);
    });

    testWidgets('valide les champs vides et affiche les erreurs', (
      tester,
    ) async {
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (_) => TodoProvider(),
          child: MaterialApp(home: RegisterScreen()),
        ),
      );

      await tester.tap(find.text("S'inscrire"));
      await tester.pumpAndSettle();

      expect(find.text('Email requis'), findsOneWidget);
      expect(
        find.text('Mot de passe requis'),
        findsNWidgets(2),
      ); // mdp + confirmation
    });

    testWidgets('toggle visibilité des mots de passe', (tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (_) => TodoProvider(),
          child: MaterialApp(home: RegisterScreen()),
        ),
      );

      // deux champs de mot de passe -> deux icônes visibility
      expect(find.byIcon(Icons.visibility_outlined), findsNWidgets(2));

      await tester.tap(find.byIcon(Icons.visibility_outlined).first);
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.visibility_off_outlined), findsOneWidget);

      await tester.tap(find.byIcon(Icons.visibility_outlined).last);
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.visibility_off_outlined), findsNWidgets(2));
    });

    testWidgets('valide que les mots de passe correspondent', (tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (_) => TodoProvider(),
          child: MaterialApp(home: RegisterScreen()),
        ),
      );

      await tester.enterText(find.byType(TextFormField).at(0), 'a@b.com');
      await tester.enterText(find.byType(TextFormField).at(1), '123456');
      await tester.enterText(find.byType(TextFormField).at(2), '654321');

      await tester.tap(find.text("S'inscrire"));
      await tester.pumpAndSettle();

      expect(
        find.text("Les mots de passe ne correspondent pas"),
        findsOneWidget,
      );
    });
  });
}
