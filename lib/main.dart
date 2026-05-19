import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:antipanic_app/repositories/shared_prefs_repository.dart';

void main() async {
  // Core Flutter engine initialization required for native platform channels
  WidgetsFlutterBinding.ensureInitialized();

  // Asynchronously resolve hardware persistence on the main thread before frame zero
  final sharedPreferencesInstance = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [
        // Inject the fully ready hardware instance directly into the Riverpod dependency graph
        sharedPreferencesProvider.overrideWithValue(sharedPreferencesInstance),
      ],
      child: const TossACoinApp(),
    ),
  );
}

class TossACoinApp extends StatelessWidget {
  const TossACoinApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Toss A Coin — Collector Edition',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFFD700), // Procedural gold primary token
          brightness: Brightness.dark,
        ),
      ),
      home: const Scaffold(
        body: Center(
          child: Text(
            'Toss A Coin — Modulo 1 Inizializzato',
            style: TextStyle(
              fontSize: 18, 
              fontWeight: FontWeight.bold,
              color: Color(0xFFFFD700),
            ),
          ),
        ),
      ),
    );
  }
}