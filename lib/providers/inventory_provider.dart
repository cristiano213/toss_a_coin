import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Strict relative imports come da convenzioni operative
import '../core/constants.dart';
import '../models/skin_model.dart';
import '../repositories/shared_prefs_repository.dart';

/// State representation holding the equipped skin ID and the set of unlocked IDs.
/// Fields are declared final to guarantee data immutability.
class InventoryState {
  final String activeSkinId;
  final Set<String> unlockedSkinIds;

  const InventoryState({
    required this.activeSkinId,
    required this.unlockedSkinIds,
  });

  InventoryState copyWith({
    String? activeSkinId,
    Set<String>? unlockedSkinIds,
  }) {
    return InventoryState(
      activeSkinId: activeSkinId ?? this.activeSkinId,
      unlockedSkinIds: unlockedSkinIds ?? this.unlockedSkinIds,
    );
  }
}

/// Reactive manager handling the logic, updates and disk saving for the player inventory.
/// Migrated to Riverpod 2.5+ Notifier syntax for native [ref] access and cleaner lifecycle.
class InventoryNotifier extends Notifier<InventoryState> {
  
  @override
  InventoryState build() {
    // L'inizializzazione avviene in sicurezza nel frame zero leggendo il repository
    return _loadInventoryFromDisk();
  }

  /// Internal synchronization reading local JSON structures securely.
  InventoryState _loadInventoryFromDisk() {
    final repo = ref.read(sharedPrefsRepositoryProvider);
    
    final cachedActive = repo.getString(StorageKeys.activeSkinId);
    final cachedUnlockedJson = repo.getString(StorageKeys.unlockedSkins);

    String activeId = GachaPool.defaultSkin.id;
    Set<String> unlockedIds = {GachaPool.defaultSkin.id};

    if (cachedActive != null && GachaPool.registry.containsKey(cachedActive)) {
      activeId = cachedActive;
    }

    if (cachedUnlockedJson != null) {
      try {
        final List<dynamic> decodedList = jsonDecode(cachedUnlockedJson);
        final parsedIds = decodedList
            .map((e) => e.toString())
            .where((id) => GachaPool.registry.containsKey(id));
            
        if (parsedIds.isNotEmpty) {
          unlockedIds = parsedIds.toSet();
          // Safety fallback: ensure default skin is always present
          unlockedIds.add(GachaPool.defaultSkin.id);
        }
      } catch (_) {
        // Enforce structural safety on corrupted data loads
      }
    }

    return InventoryState(activeSkinId: activeId, unlockedSkinIds: unlockedIds);
  }

  /// Equip an unlocked skin and save the choice instantly to hardware storage.
  Future<bool> equipSkin(String skinId) async {
    if (!state.unlockedSkinIds.contains(skinId) || !GachaPool.registry.containsKey(skinId)) {
      return false;
    }
    
    state = state.copyWith(activeSkinId: skinId);
    
    final repo = ref.read(sharedPrefsRepositoryProvider);
    return await repo.setString(StorageKeys.activeSkinId, skinId);
  }

  /// Unlock a new skin (called by the Gacha engine). Returns true if it's a new drop,
  /// or false if it was already unlocked (duplicate scenario for economy handling).
  Future<bool> unlockSkin(String skinId) async {
    if (!GachaPool.registry.containsKey(skinId)) return false;
    
    final alreadyUnlocked = state.unlockedSkinIds.contains(skinId);
    if (alreadyUnlocked) return false; 

    final updatedUnlocked = Set<String>.from(state.unlockedSkinIds)..add(skinId);
    state = state.copyWith(unlockedSkinIds: updatedUnlocked);

    final jsonString = jsonEncode(updatedUnlocked.toList());
    final repo = ref.read(sharedPrefsRepositoryProvider);
    await repo.setString(StorageKeys.unlockedSkins, jsonString);
    return true;
  }
}

/// Global provider giving access to the inventory business logic layer.
final inventoryProvider = NotifierProvider<InventoryNotifier, InventoryState>(() {
  return InventoryNotifier();
});

/// Specialized read-only provider returning the exact compiled SkinModel currently active.
final currentSkinModelProvider = Provider<SkinModel>((ref) {
  final inventory = ref.watch(inventoryProvider);
  return GachaPool.registry[inventory.activeSkinId] ?? GachaPool.defaultSkin;
});