import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/constants.dart';
import '../models/skin_model.dart';
import '../repositories/shared_prefs_repository.dart';

/// State representation holding the equipped skin ID and the set of unlocked IDs.
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

/// Notifier handling the logic, updates and disk saving for the player inventory.
class InventoryNotifier extends StateNotifier<InventoryState> {
  final SharedPrefsRepository _repository;

  // CORREZIONE: Usiamo la stringa hardcoded 'skin_classic_gold' per evitare il blocco const di Dart
  InventoryNotifier(this._repository)
      : super(const InventoryState(
          activeSkinId: 'skin_classic_gold',
          unlockedSkinIds: {'skin_classic_gold'},
        )) {
    _loadInventoryFromDisk();
  }

  /// Internal synchronization reading local JSON structures securely.
  void _loadInventoryFromDisk() {
    final cachedActive = _repository.getString(StorageKeys.activeSkinId);
    final cachedUnlockedJson = _repository.getString(StorageKeys.unlockedSkins);

    String activeId = GachaPool.defaultSkin.id;
    Set<String> unlockedIds = {GachaPool.defaultSkin.id};

    if (cachedActive != null && GachaPool.registry.containsKey(cachedActive)) {
      activeId = cachedActive;
    }

    if (cachedUnlockedJson != null) {
      try {
        final List<dynamic> decodedList = jsonDecode(cachedUnlockedJson);
        final parsedIds = decodedList.map((e) => e.toString()).where((id) => GachaPool.registry.containsKey(id));
        if (parsedIds.isNotEmpty) {
          unlockedIds = parsedIds.toSet();
          // Safety fallback: ensure default skin is always present
          unlockedIds.add(GachaPool.defaultSkin.id);
        }
      } catch (_) {
        // Enforce structural safety on corrupted data loads
      }
    }

    state = InventoryState(activeSkinId: activeId, unlockedSkinIds: unlockedIds);
  }

  /// Equip an unlocked skin and save the choice instantly to hardware storage.
  Future<bool> equipSkin(String skinId) async {
    if (!state.unlockedSkinIds.contains(skinId) || !GachaPool.registry.containsKey(skinId)) {
      return false;
    }
    
    state = state.copyWith(activeSkinId: skinId);
    return await _repository.setString(StorageKeys.activeSkinId, skinId);
  }

  /// Unlock a new skin (called by the Gacha engine). Returns true if it's a new drop,
  /// or false if it was already unlocked (duplicate scenario).
  Future<bool> unlockSkin(String skinId) async {
    if (!GachaPool.registry.containsKey(skinId)) return false;
    
    final alreadyUnlocked = state.unlockedSkinIds.contains(skinId);
    if (alreadyUnlocked) return false; 

    final updatedUnlocked = Set<String>.from(state.unlockedSkinIds)..add(skinId);
    state = state.copyWith(unlockedSkinIds: updatedUnlocked);

    final jsonString = jsonEncode(updatedUnlocked.toList());
    await _repository.setString(StorageKeys.unlockedSkins, jsonString);
    return true;
  }
}

/// Global provider giving access to the inventory business logic layer.
final inventoryProvider = StateNotifierProvider<InventoryNotifier, InventoryState>((ref) {
  final repo = ref.watch(sharedPrefsRepositoryProvider);
  return InventoryNotifier(repo);
});

/// Specialized read-only provider returning the exact compiled SkinModel currently active.
final currentSkinModelProvider = Provider<SkinModel>((ref) {
  final inventory = ref.watch(inventoryProvider);
  return GachaPool.registry[inventory.activeSkinId] ?? GachaPool.defaultSkin;
});