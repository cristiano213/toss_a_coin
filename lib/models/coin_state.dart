import 'package:flutter/foundation.dart';

enum CoinSide { heads, tails }

@immutable
class CoinState {
  final CoinSide? result;
  final bool isSpinning;
  final int consecutiveHeads;
  final int consecutiveTails;

  const CoinState({
    this.result,
    this.isSpinning = false,
    this.consecutiveHeads = 0,
    this.consecutiveTails = 0,
  });

  CoinState copyWith({
    CoinSide? result,
    bool? isSpinning,
    int? consecutiveHeads,
    int? consecutiveTails,
  }) {
    return CoinState(
      result: result ?? this.result,
      isSpinning: isSpinning ?? this.isSpinning,
      consecutiveHeads: consecutiveHeads ?? this.consecutiveHeads,
      consecutiveTails: consecutiveTails ?? this.consecutiveTails,
    );
  }
}