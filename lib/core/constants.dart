import '../models/skin_model.dart';

/// Centralized hardware storage keys used across SharedPreferences layers.
class StorageKeys {
  static const String activeSkinId = 'ts_active_skin_id';
  static const String unlockedSkins = 'ts_unlocked_skins_json';
  static const String gemsCount = 'ts_gems_count';
  static const String pityCounter = 'ts_gacha_pity_counter';
}

/// Authoritative immutable registry containing all procedural skins and configurations.
class GachaPool {
  /// The base skin assigned to every player at boot zero.
  static const SkinModel defaultSkin = SkinModel(
    id: 'skin_classic_gold',
    name: 'Classic Gold',
    rarity: SkinRarity.common,
    frontGradientHex: [
      0xFFFFE259, // Gold top light
      0xFFFFA751, // Warm copper blend
      0xFFFFD700, // Core pure gold
      0xFFB8860B, // Darker gold shade
    ],
    backGradientHex: [
      0xFFF0F0F0, // Silver high reflections
      0xFFB0B3B6, // Medium silver specular
      0xFFE0E0E0, // Core reflection gray
      0xFF757575, // Deep ambient shadow
    ],
    borderHex: 0xFFFFD700, // Matching core gold border
    hasGlowEffect: false,
  );

  /// 4-Star Rare Skin: Advanced metallic sapphire look
  static const SkinModel rareSapphire = SkinModel(
    id: 'skin_rare_sapphire',
    name: 'Sapphire Matrix',
    rarity: SkinRarity.rare,
    frontGradientHex: [
      0xFF00c6ff, // Electric light blue
      0xFF0072ff, // Deep royal sapphire
    ],
    backGradientHex: [
      0xFF3a7bd5, // Slate blue metallic
      0xFF3a6073, // Ocean shadow gray
    ],
    borderHex: 0xFF0072ff,
    hasGlowEffect: false,
  );

  /// 5-Star Legendary Skin: Hyper-fused cosmic obsidian with active emission glow
  static const SkinModel legendaryVoid = SkinModel(
    id: 'skin_legendary_void',
    name: 'Void Singularity',
    rarity: SkinRarity.legendary,
    frontGradientHex: [
      0xFFf12711, // Supernova core orange
      0xFFf5af19, // Flare flash yellow
    ],
    backGradientHex: [
      0xFF414345, // Heavy dark steel
      0xFF232526, // Deep deep carbon black
    ],
    borderHex: 0xFFf12711, // Radiant reactive border
    hasGlowEffect: true, // Triggers advanced blur & expanded footprint inside CoinVisual
  );

  /// Global lookup dictionary used by Gacha engines and Inventory providers to map entities.
  static const Map<String, SkinModel> registry = {
    'skin_classic_gold': defaultSkin,
    'skin_rare_sapphire': rareSapphire,
    'skin_legendary_void': legendaryVoid,
  };
}