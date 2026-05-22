import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants.dart';
import '../../providers/inventory_provider.dart';

/// Read-Only view rendering the complete registry of existant skins.
/// Unlocked skins appear full-color, while locked ones are monochromatized.
class ArchivePage extends ConsumerWidget {
  const ArchivePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inventory = ref.watch(inventoryProvider);
    final allSkins = GachaPool.registry.values.toList();

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.8,
      ),
      itemCount: allSkins.length,
      itemBuilder: (context, index) {
        final skin = allSkins[index];
        final isUnlocked = inventory.unlockedSkinIds.contains(skin.id);

        return ColorFiltered(
          colorFilter: isUnlocked 
              ? const ColorFilter.matrix(<double>[
                  1, 0, 0, 0, 0,
                  0, 1, 0, 0, 0,
                  0, 0, 1, 0, 0,
                  0, 0, 0, 1, 0,
                ])
              : const ColorFilter.matrix(<double>[
                  0.2126, 0.7152, 0.0722, 0, 0,
                  0.2126, 0.7152, 0.0722, 0, 0,
                  0.2126, 0.7152, 0.0722, 0, 0,
                  0,      0,      0,      1, 0,
                ]),
          child: Card(
            clipBehavior: Clip.antiAlias,
            elevation: isUnlocked ? 4 : 1,
            child: Stack(
              children: [
                Center(
                  child: Text(
                    skin.name, 
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                if (!isUnlocked)
                  const Positioned(
                    top: 8,
                    right: 8,
                    child: Icon(Icons.lock, color: Colors.grey, size: 20),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}