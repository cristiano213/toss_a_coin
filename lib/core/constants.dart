import '../models/skin_model.dart';

class StorageKeys {
  static const String activeSkinId = 'tac_active_skin_id';
  static const String unlockedSkins = 'tac_unlocked_skins_list';
  static const String gemBalance = 'tac_gem_balance_count';
}

class GachaPool {
  /// Default skin granted to every account on first boot.
  static const SkinModel defaultSkin = SkinModel(
    id: 'skin_classic_gold',
    name: 'Classic Gold',
    rarity: SkinRarity.common,
    frontGradientHex: [0xFFFFE066, 0xFFF5B041, 0xFFD35400], // Rich Gold
    backGradientHex: [0xFFBDC3C7, 0xFF95A5A6, 0xFF7F8C8D],  // Solid Silver
    borderHex: 0xFF9A7D0A,
    hasGlowEffect: false,
  );

  /// Global list of all procedural skins pullable from the Gacha simulator.
  static const List<SkinModel> allSkins = [
    defaultSkin,
    SkinModel(
      id: 'skin_cyber_pulse',
      name: 'Cyber Pulse',
      rarity: SkinRarity.rare,
      frontGradientHex: [0xFF00F2FE, 0xFF4FACFE], // Neon Cyan / Electric Blue
      backGradientHex: [0xFFF355DA, 0xFF700699],  // Cyber Magenta
      borderHex: 0xFF00F2FE,
      hasGlowEffect: false,
    ),
    SkinModel(
      id: 'skin_dark_void',
      name: 'Dark Void',
      rarity: SkinRarity.rare,
      frontGradientHex: [0xFF232526, 0xFF414345], // Obsidian Black
      backGradientHex: [0xFF141E30, 0xFF243B55],  // Deep Midnight
      borderHex: 0xFF414345,
      hasGlowEffect: false,
    ),
    SkinModel(
      id: 'skin_cosmic_glow',
      name: 'Cosmic Glow',
      rarity: SkinRarity.legendary,
      frontGradientHex: [0xFF8A2387, 0xFFE94057, 0xFFF27121], // Nebula Gradient
      backGradientHex: [0xFF4A0E4E, 0xFF1F1C2C],  // Deep Cosmos Space
      borderHex: 0xFFFFD700,
      hasGlowEffect: true, // Triggers engine-level glowing rendering wrappers
    ),
  ];

  /// Fast lookup map to retrieve skin models by unique identifier.
  static final Map<String, SkinModel> registry = {
    for (var skin in allSkins) skin.id: skin,
  };
} 