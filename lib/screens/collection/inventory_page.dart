import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants.dart';
import '../../providers/inventory_provider.dart';

/// Interactivre Loadout view displaying strictly the unlocked skins owned by the user.
class InventoryPage extends ConsumerWidget {
  const InventoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inventory = ref.watch(inventoryProvider);
    
    // Filtriamo la pool tenendo solo ciò che l'utente possiede realmente
    final ownedSkins = GachaPool.registry.values
        .where((skin) => inventory.unlockedSkinIds.contains(skin.id))
        .toList();

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: ownedSkins.length,
      itemBuilder: (context, index) {
        final skin = ownedSkins[index];
        final isActive = inventory.activeSkinId == skin.id;

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          borderOnForeground: true,
          shape: isActive 
              ? RoundedRectangleBorder(side: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2), borderRadius: BorderRadius.circular(12))
              : null,
          child: ListTile(
            title: Text(skin.name),
            subtitle: Text('Rarità: ${skin.rarity.name.toUpperCase()}'),
            trailing: isActive 
                ? const Icon(Icons.check_circle, color: Colors.green)
                : ElevatedButton(
                    onPressed: () async {
                      await ref.read(inventoryProvider.notifier).equipSkin(skin.id);
                    },
                    child: const Text('Equipaggia'),
                  ),
          ),
        );
      },
    );
  }
}