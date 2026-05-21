import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/skin_model.dart';
import '../providers/gacha_provider.dart';
import '../providers/gem_provider.dart';

class GachaScreen extends ConsumerWidget {
  const GachaScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Monitoraggio dei provider economici e statistici
    final gemBalance = ref.watch(gemProvider);
    final gachaState = ref.watch(gachaProvider);
    final gachaNotifier = ref.read(gachaProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tempio Gacha'),
        centerTitle: true,
        actions: [
          // Visualizzazione del bilancio gemme nell'appbar per controllo immediato
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                const Icon(Icons.diamond, color: Colors.cyan, size: 20),
                const SizedBox(width: 4),
                Text(
                  '$gemBalance',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Pannello informativo sul Pity Counter corrente
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Progressione Pity (Garantito 5★ a 90)',
                            style: TextStyle(fontSize: 14, color: Colors.white70),
                          ),
                          Text(
                            '${gachaState.pityCounter} / 90',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      // Barra lineare che mostra visivamente l'avvicinamento al soft/hard pity
                      LinearProgressIndicator(
                        value: gachaState.pityCounter / 90.0,
                        backgroundColor: Colors.white10,
                        color: gachaState.pityCounter >= 50 ? Colors.orangeAccent : Colors.amber,
                        minHeight: 8,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Sezione dinamica centrale: mostra i risultati dell'ultimo pull o un placeholder
              Expanded(
                child: gachaState.latestDrops.isEmpty
                    ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.auto_awesome, size: 48, color: Colors.white24),
                            SizedBox(height: 12),
                            Text(
                              'Tenta la fortuna per sbloccare nuove skin procedurali',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white30),
                            )
                          ],
                        ),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Ultimi Reperti Estratti:',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              TextButton(
                                onPressed: () => gachaNotifier.clearLatestDrops(),
                                child: const Text('Pulisci storco'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Expanded(
                            child: GridView.builder(
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                                childAspectRatio: 1.3,
                              ),
                              itemCount: gachaState.latestDrops.length,
                              itemBuilder: (context, index) {
                                final skin = gachaState.latestDrops[index];
                                return _buildDropCard(skin);
                              },
                            ),
                          ),
                        ],
                      ),
              ),

              const SizedBox(height: 20),

              // Pannello di comando inferiore: Pulsanti di interazione x1 e x10
              Row(
                children: [
                  // Pulsante Singolo Pull (Costo 100)
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Colors.white10,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: gemBalance < 100 ? null : () => gachaNotifier.pullSingle(),
                      child: const Column(
                        children: [
                          Text('Evocazione Singola', style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.diamond, size: 14, color: Colors.cyan),
                              SizedBox(width: 2),
                              Text('100', style: TextStyle(fontSize: 12)),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Pulsante Multi-Pull x10 (Costo 1000)
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Colors.amber,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: gemBalance < 1000 ? null : () => gachaNotifier.pullMulti(),
                      child: const Column(
                        children: [
                          Text('Multi Evocazione x10', style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.diamond, size: 14, color: Colors.black87),
                              SizedBox(width: 2),
                              Text('1000', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                            ],
                          )
                        ],
                      ),
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

  /// Widget helper atomico per renderizzare visivamente il Tier di rarità estratto
  Widget _buildDropCard(SkinModel skin) {
    // Assegnazione colore ed etichetta testuale in base all'enum nativo
    final Color rarityColor;
    final String rarityText;

    switch (skin.rarity) {
      case SkinRarity.legendary:
        rarityColor = Colors.orange;
        rarityText = '5★ LEGENDARY';
        break;
      case SkinRarity.rare:
        rarityColor = Colors.purpleAccent;
        rarityText = '4★ RARE';
        break;
      case SkinRarity.common:
        rarityColor = Colors.blueGrey;
        rarityText = '3★ COMMON';
        break;
    }

    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: rarityColor.withValues(alpha: 0.5), width: 1.5),
      ),
      child: Stack(
        children: [
          // Sfondo procedurale basato sul gradiente effettivo della skin estratta
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: skin.frontColors.map((c) => c.withValues(alpha: 0.25)).toList(),
              ),
            ),
          ),
          // Contenuto informativo interno della card
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  rarityText,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: rarityColor,
                    letterSpacing: 1,
                  ),
                ),
                Text(
                  skin.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                // Rappresentazione in miniatura del cerchio della moneta procedurale
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(colors: skin.frontColors),
                        border: Border.all(color: Color(skin.borderHex), width: 1.5),
                        boxShadow: skin.hasGlowEffect
                            ? [BoxShadow(color: Color(skin.borderHex).withValues(alpha: 0.6), blurRadius: 8)]
                            : null,
                      ),
                    ),
                    if (skin.hasGlowEffect)
                      const Icon(Icons.flash_on, size: 16, color: Colors.orangeAccent),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}