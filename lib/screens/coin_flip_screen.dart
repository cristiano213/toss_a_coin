import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/theme.dart';
import '../models/coin_state.dart';
import '../providers/coin_provider.dart';
import '../providers/gem_provider.dart';
import '../widgets/coin_visual.dart';

class CoinFlipScreen extends ConsumerWidget {
  const CoinFlipScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coinState = ref.watch(coinProvider);
    final gemBalance = ref.watch(gemProvider);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('TOSS A COIN', style: Theme.of(context).textTheme.headlineMedium),
                    Row(
                      children: [
                        const Icon(Icons.diamond, color: AppColors.primary, size: 24),
                        const SizedBox(width: 8),
                        Text(
                          '$gemBalance',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Spacer(),
              
              Center(
                child: CoinVisual(
                  isSpinning: coinState.isSpinning,
                  result: coinState.result,
                ),
              ),
              const SizedBox(height: 40),
              
              Center(
                child: Text(
                  coinState.isSpinning
                      ? 'Il destino sta girando...'
                      : coinState.result == null
                          ? 'Scegli una faccia e lancia!'
                          : 'Risultato: ${coinState.result == CoinSide.heads ? "TESTA (O)" : "CROCE (X)"}',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
              ),
              
              // NUOVO ELEMENTO: Pulsante Centrale per il lancio libero condizionato
              const SizedBox(height: 16),
              SizedBox(
                height: 48, // Altezza fissa per evitare sbalzi di layout distruttivi
                child: coinState.isSpinning
                    ? null // Scompare visivamente durante il volo per pulizia UX
                    : Center(
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white70,
                            side: const BorderSide(color: Colors.white24),
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                          ),
                          onPressed: () => ref.read(coinProvider.notifier).flipCoin(null),
                          icon: const Icon(Icons.casino, size: 18, color: Colors.grey),
                          label: const Text('Lancio Libero', style: TextStyle(fontSize: 14)),
                        ),
                      ),
              ),
              
              const Spacer(),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text('Win streak Testa: ${coinState.consecutiveHeads}', style: const TextStyle(color: Colors.grey)),
                  Text('Win streak Croce: ${coinState.consecutiveTails}', style: const TextStyle(color: Colors.grey)),
                ],
              ),
              const SizedBox(height: 24),

              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber.shade700,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: coinState.isSpinning 
                          ? null 
                          : () => ref.read(coinProvider.notifier).flipCoin(CoinSide.heads),
                      child: const Text('Scommetti TESTA (O)', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade700,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: coinState.isSpinning 
                          ? null 
                          : () => ref.read(coinProvider.notifier).flipCoin(CoinSide.tails),
                      child: const Text('Scommetti CROCE (X)', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}