import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/coin_state.dart';
import 'gem_provider.dart';

class CoinNotifier extends Notifier<CoinState> {
  final Random _random = Random();

  @override
  CoinState build() {
    return const CoinState();
  }

  // Corretto: adesso prediction accetta "null" per il lancio libero
  Future<void> flipCoin(CoinSide? prediction) async {
    if (state.isSpinning) return;

    state = state.copyWith(isSpinning: true);

    await Future.delayed(const Duration(milliseconds: 1500));

    final CoinSide finalResult = _random.nextBool() ? CoinSide.heads : CoinSide.tails;

    int newHeads = finalResult == CoinSide.heads ? state.consecutiveHeads + 1 : 0;
    int newTails = finalResult == CoinSide.tails ? state.consecutiveTails + 1 : 0;

    state = state.copyWith(
      result: finalResult,
      isSpinning: false,
      consecutiveHeads: newHeads,
      consecutiveTails: newTails,
    );

    // Gestione Economica Condizionale: assegna gemme SOLO se c'è una scommessa reale
    if (prediction != null) {
      final bool hasWon = finalResult == prediction;
      final int reward = hasWon ? 100 : 25;
      ref.read(gemProvider.notifier).addGems(reward);
    }
  }
}

final coinProvider = NotifierProvider<CoinNotifier, CoinState>(() {
  return CoinNotifier();
});