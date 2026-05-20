import 'package:flutter/material.dart';
import 'skin_model.dart';

@immutable
class GachaState {
  /// Quanti pull consecutivi sono stati effettuati senza trovare un oggetto 5-stelle.
  final int pityCounter;

  /// La lista di skin estratte nell'ultimo ciclo di pull (vuota a riposo).
  final List<SkinModel> latestDrops;

  const GachaState({
    required this.pityCounter,
    required this.latestDrops,
  });

  /// Stato iniziale pulito al boot dell'applicazione.
  factory GachaState.initial() {
    return const GachaState(
      pityCounter: 0,
      latestDrops: [],
    );
  }

  /// Mutatore deep copy per garantire l'immutabilità dello stato.
  GachaState copyWith({
    int? pityCounter,
    List<SkinModel>? latestDrops,
  }) {
    return GachaState(
      pityCounter: pityCounter ?? this.pityCounter,
      latestDrops: latestDrops ?? this.latestDrops,
    );
  }
}