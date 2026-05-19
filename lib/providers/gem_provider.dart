import 'package:flutter_riverpod/flutter_riverpod.dart';

// Il Notifier che gestisce il bilancio intero delle gemme
class GemNotifier extends Notifier<int> {
  @override
  int build() {
    return 1000; // Saldo iniziale di partenza (permette subito un multi-pull di test nel gacha)
  }

  void addGems(int amount) {
    state = state + amount;
  }

  bool spendGems(int amount) {
    if (state >= amount) {
      state = state - amount;
      return true;
    }
    return false; // Fondi insufficienti
  }
}

// Dichiarazione del provider globale come top-level constant
final gemProvider = NotifierProvider<GemNotifier, int>(() {
  return GemNotifier();
}); 