import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'firebase_options.dart';

import 'providers/todo_provider.dart';
import 'screens/home_screen.dart';
import 'screens/register_screen.dart';
import 'screens/login_screen.dart';

// Démarrer avec : flutter run -d chrome --dart-define=USE_EMULATORS=true
const bool kUseEmulators = bool.fromEnvironment('USE_EMULATORS');

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Persistance offline Firestore
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
  );

  if (kUseEmulators) {
    try {
      await FirebaseAuth.instance.useAuthEmulator('127.0.0.1', 9099);
      FirebaseFirestore.instance.useFirestoreEmulator('127.0.0.1', 8080);
    } catch (_) {}
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TodoProvider()),
        StreamProvider<User?>(
          create: (_) => FirebaseAuth.instance.authStateChanges(),
          initialData: null,
        ),
      ],
      child: const MyApp(key: ValueKey('app')),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TodoApp',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.indigo),
      home: const _Gate(key: ValueKey('_gate')),
      routes: {
        '/login': (_) => const LoginScreen(key: ValueKey('login')),
        '/register': (_) => const RegisterScreen(key: ValueKey('register')),
      },
    );
  }
}

class _Gate extends StatelessWidget {
  const _Gate({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<User?>();
    if (user == null) {
      return const RegisterScreen(key: ValueKey('register'));
    }
    return const HomeScreen(key: ValueKey('home'));
  }
}
