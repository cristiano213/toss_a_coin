import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/coin_state.dart';
import '../providers/inventory_provider.dart';

class CoinVisual extends ConsumerStatefulWidget {
  final bool isSpinning;
  final CoinSide? result;

  const CoinVisual({
    required this.isSpinning,
    required this.result,
    super.key,
  });

  @override
  ConsumerState<CoinVisual> createState() => _CoinVisualState();
}

class _CoinVisualState extends ConsumerState<CoinVisual> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0.0, end: pi * 8).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutCubic),
    );
  }

  @override
  void didUpdateWidget(covariant CoinVisual oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSpinning && !oldWidget.isSpinning) {
      _controller.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Osserva dinamicamente la skin attiva dal provider di Riverpod
    final skin = ref.watch(currentSkinModelProvider);

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        double angle = _animation.value;
        
        // FISICA E ANCORAGGIO IDENTICI: Manteniamo intatta la tua logica di stabilizzazione
        final bool showHeads;
        if (widget.isSpinning || _controller.isAnimating) {
          showHeads = (((angle / pi).round() % 2) == 0);
        } else {
          showHeads = (widget.result == CoinSide.heads || widget.result == null);
        }

        // Estrazione dinamica del gradiente in base alla faccia visibile
        final currentGradient = showHeads ? skin.frontColors : skin.backColors;
        
        // Risoluzione dinamica del colore del bordo (evita il grigio fisso sul retro)
        final currentBorderColor = showHeads 
            ? skin.borderColor 
            : skin.backColors.last.withValues(alpha: 0.8);

        return Transform(
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.002)
            ..rotateY(angle),
          alignment: Alignment.center,
          child: Container(
            width: 180,
            height: 180,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: currentGradient,
              ),
              boxShadow: [
                BoxShadow(
                  color: (showHeads ? skin.borderColor : Colors.white)
                      .withValues(alpha: skin.hasGlowEffect ? 0.65 : 0.3),
                  blurRadius: skin.hasGlowEffect ? 35 : 20,
                  spreadRadius: skin.hasGlowEffect ? 5 : 2,
                ),
                const BoxShadow(
                  color: Colors.black54,
                  offset: Offset(0, 10),
                  blurRadius: 15,
                )
              ],
              border: Border.all(
                color: currentBorderColor,
                width: 5,
              ),
            ),
            child: Center(
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: (showHeads ? skin.borderColor : skin.backColors.first)
                        .withValues(alpha: 0.4),
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Text(
                    showHeads ? 'O' : 'X',
                    style: TextStyle(
                      fontSize: 64,
                      fontWeight: FontWeight.bold,
                      // Il testo si adatta al colore di contrasto definito o calcolato della skin
                      color: showHeads 
                          ? (skin.borderHex == 0xFF414345 ? Colors.white : const Color(0xFF1C1C1E))
                          : skin.backColors.last.withValues(alpha: 0.9),
                      shadows: const [
                        Shadow(
                          color: Colors.white24, 
                          offset: Offset(1, 1), 
                          blurRadius: 1,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}