import 'package:flutter/material.dart';

/// Rarity tiers mapped directly from functional requirements.
/// Enhanced enum structure avoids external json_annotation dependencies.
enum SkinRarity {
  common('3-star'),
  rare('4-star'),
  legendary('5-star');

  final String jsonKey;
  const SkinRarity(this.jsonKey);

  /// Safe lookup to find the rarity by its custom JSON string key.
  static SkinRarity fromJsonKey(String key) {
    return SkinRarity.values.firstWhere(
      (element) => element.jsonKey == key,
      orElse: () => SkinRarity.common,
    );
  }
}

/// Immutable structural model defining a procedural visual skin.
class SkinModel {
  final String id;
  final String name;
  final SkinRarity rarity;
  
  /// Hexadecimal color values for the front side (e.g., Gold variant)
  final List<int> frontGradientHex;
  
  /// Hexadecimal color values for the back side (e.g., Silver variant)
  final List<int> backGradientHex;
  
  final int borderHex;
  final bool hasGlowEffect;

  const SkinModel({
    required this.id,
    required this.name,
    required this.rarity,
    required this.frontGradientHex,
    required this.backGradientHex,
    required this.borderHex,
    this.hasGlowEffect = false,
  });

  /// Deep copy mutator ensuring structural immutability.
  SkinModel copyWith({
    String? id,
    String? name,
    SkinRarity? rarity,
    List<int>? frontGradientHex,
    List<int>? backGradientHex,
    int? borderHex,
    bool? hasGlowEffect,
  }) {
    return SkinModel(
      id: id ?? this.id,
      name: name ?? this.name,
      rarity: rarity ?? this.rarity,
      frontGradientHex: frontGradientHex ?? this.frontGradientHex,
      backGradientHex: backGradientHex ?? this.backGradientHex,
      borderHex: borderHex ?? this.borderHex,
      hasGlowEffect: hasGlowEffect ?? this.hasGlowEffect,
    );
  }

  /// Maps the model state into a standard JSON dictionary.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'rarity': rarity.jsonKey, // Uses the explicit clean string key
      'front_gradient_hex': frontGradientHex,
      'back_gradient_hex': backGradientHex,
      'border_hex': borderHex,
      'has_glow_effect': hasGlowEffect,
    };
  }

  /// Factory constructor parsing storage JSON layers back into typed models.
  factory SkinModel.fromJson(Map<String, dynamic> json) {
    return SkinModel(
      id: json['id'] as String,
      name: json['name'] as String,
      rarity: SkinRarity.fromJsonKey(json['rarity'] as String), // Safe mapping back
      frontGradientHex: List<int>.from(json['front_gradient_hex'] as List),
      backGradientHex: List<int>.from(json['back_gradient_hex'] as List),
      borderHex: json['border_hex'] as int,
      hasGlowEffect: json['has_glow_effect'] as bool? ?? false,
    );
  }

  /// Helper utilities to instantly transform hex storage into UI Flutter Colors.
  List<Color> get frontColors => frontGradientHex.map((hex) => Color(hex)).toList();
  List<Color> get backColors => backGradientHex.map((hex) => Color(hex)).toList();
  Color get borderColor => Color(borderHex);
}