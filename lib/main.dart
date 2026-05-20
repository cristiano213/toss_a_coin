import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
// Manteniamo l'import assoluto nativo corretto del tuo progetto
import 'package:antipanic_app/repositories/shared_prefs_repository.dart';
import 'screens/main_navigation_hub.dart';

void main() async {
  // Inizializzazione del binding nativo di Flutter richiesta prima dell'esecuzione di codice asincrono
  WidgetsFlutterBinding.ensureInitialized();

  // Pre-caricamento sincrono/asincrono dell'istanza hardware sul thread principale prima del frame zero
  final sharedPreferencesInstance = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [
        // Iniettiamo l'istanza pronta direttamente dentro il provider del nostro repository personalizzato
        sharedPrefsRepositoryProvider.overrideWithValue(SharedPrefsRepository(sharedPreferencesInstance)),
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
          seedColor: const Color(0xFFFFD700), // Token primario basato sull'oro procedurale
          brightness: Brightness.dark,
        ),
      ),
      // Carica lo Shell di navigazione centrale dell'app
      home: const MainNavigationHub(),
    );
  }
}