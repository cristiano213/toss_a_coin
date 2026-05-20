import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/constants.dart';
import '../models/gacha_state.dart';
import '../models/skin_model.dart';
import 'gem_provider.dart';
import 'inventory_provider.dart';

class GachaNotifier extends Notifier<GachaState> {
  final Random _random = Random();

  @override
  GachaState build() {
    return GachaState.initial();
  }

  /// Esegue un singolo tentativo di estrazione (Costo: 100 Gemme).
  Future<void> pullSingle() async {
    final gemNotifier = ref.read(gemProvider.notifier);
    
    // Verifica e consuma la valuta prima di procedere
    if (!gemNotifier.spendGems(100)) {
      return; // Fondi insufficienti, operazione interrotta
    }

    int currentPity = state.pityCounter;
    final List<SkinModel> droppedSkins = [];

    // Esegue una singola estrazione atomica
    final result = _executeSinglePull(currentPity);
    droppedSkins.add(result.skin);
    currentPity = result.newPity;

    // Aggiorna lo stato finale con l'esito dell'estrazione
    state = state.copyWith(
      pityCounter: currentPity,
      latestDrops: droppedSkins,
    );
  }

  /// Esegue un'estrazione multipla da 10 tentativi consecutivi (Costo: 1000 Gemme).
  Future<void> pullMulti() async {
    final gemNotifier = ref.read(gemProvider.notifier);
    
    // Verifica e consuma la valuta per l'intero blocco
    if (!gemNotifier.spendGems(1000)) {
      return; 
    }

    int currentPity = state.pityCounter;
    final List<SkinModel> droppedSkins = [];

    // Esegue i 10 pull in sequenza isolata per aggiornare correttamente il pity incrementale
    for (int i = 0; i < 10; i++) {
      final result = _executeSinglePull(currentPity);
      droppedSkins.add(result.skin);
      currentPity = result.newPity;
    }

    // Unico aggiornamento dello stato per notificare la UI senza trigger ridondanti
    state = state.copyWith(
      pityCounter: currentPity,
      latestDrops: droppedSkins,
    );
  }

  /// Algoritmo probabilistico interno del Pity System.
  _PullResult _executeSinglePull(int currentPity) {
    // Incrementa il contatore locale per il pull corrente
    final int pullIndex = currentPity + 1;
    
    double fiveStarChance = 2.0; // 2% Base Chance (Pull 1-50)

    if (pullIndex >= 90) {
      fiveStarChance = 100.0; // Hard Pity al 90° pull
    } else if (pullIndex > 50) {
      // Soft Pity: +2.45% lineare per ogni pull fallito consecutivo dopo il 50°
      fiveStarChance = 2.0 + (pullIndex - 50) * 2.45;
    }

    // Genera un valore casuale tra 0.0 (incluso) e 100.0 (escluso)
    final double roll = _random.nextDouble() * 100.0;
    SkinRarity selectedRarity;

    int nextPity = pullIndex;

    if (roll < fiveStarChance) {
      selectedRarity = SkinRarity.legendary;
      nextPity = 0; // Reset completo del pity counter all'estrazione del 5-stelle
    } else if (roll < (fiveStarChance + 18.0)) {
      // 18% di probabilità fissa per il Tier 4-Stelle (Rare)
      selectedRarity = SkinRarity.rare;
    } else {
      // La probabilità rimanente assorbe il Tier 3-Stelle (Common)
      selectedRarity = SkinRarity.common;
    }

    // Filtra il registro statico globale per trovare le skin appartenenti alla rarità estratta
    final matchingSkins = GachaPool.registry.values
        .where((skin) => skin.rarity == selectedRarity)
        .toList();

    // Se per sicurezza strutturale non ci sono skin registrate per quel tier, fa fallback sulla di default
    final SkinModel selectedSkin = matchingSkins.isNotEmpty
        ? matchingSkins[_random.nextInt(matchingSkins.length)]
        : GachaPool.defaultSkin;

    // Notifica asincrona all'inventario per sbloccare la skin e salvarla su hardware
    ref.read(inventoryProvider.notifier).unlockSkin(selectedSkin.id);

    return _PullResult(skin: selectedSkin, newPity: nextPity);
  }

  /// Pulisce lo storico dei drop recenti senza resettare i contatori di pity.
  void clearLatestDrops() {
    state = state.copyWith(latestDrops: const []);
  }
}

/// Contenitore di utility interno per trasportare l'esito combinato di una singola estrazione.
class _PullResult {
  final SkinModel skin;
  final int newPity;

  const _PullResult({
    required this.skin,
    required this.newPity,
  });
}

/// Provider globale del motore Gacha accessibile dagli schermi dell'applicazione.
final gachaProvider = NotifierProvider<GachaNotifier, GachaState>(() {
  return GachaNotifier();
});