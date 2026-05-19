import 'dart:math';
import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../models/coin_state.dart';

class CoinVisual extends StatefulWidget {
  final bool isSpinning;
  final CoinSide? result;

  const CoinVisual({
    required this.isSpinning,
    required this.result,
    super.key,
  });

  @override
  State<CoinVisual> createState() => _CoinVisualState();
}

class _CoinVisualState extends State<CoinVisual> with SingleTickerProviderStateMixin {
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
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        double angle = _animation.value;
        
        // CORREZIONE LOGICA:
        // Se la moneta sta girando, alterniamo le facce matematicamente.
        // Se è ferma, la sorgente di verità assoluta diventa il widget.result.
        final bool showHeads;
        if (widget.isSpinning || _controller.isAnimating) {
          showHeads = (((angle / pi).round() % 2) == 0);
        } else {
          showHeads = (widget.result == CoinSide.heads || widget.result == null);
        }

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
                colors: showHeads ? AppColors.goldCoinGradient : AppColors.silverCoinGradient,
              ),
              boxShadow: [
                BoxShadow(
                  color: (showHeads ? AppColors.primary : Colors.white).withOpacity(0.3),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
                const BoxShadow(
                  color: Colors.black54,
                  offset: Offset(0, 10),
                  blurRadius: 15,
                )
              ],
              border: Border.all(
                color: showHeads ? const Color(0xFFB8860B) : const Color(0xFF757575),
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
                    color: (showHeads ? const Color(0xFFFFD700) : const Color(0xFFE0E0E0)).withOpacity(0.5),
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Text(
                    showHeads ? 'O' : 'X',
                    style: TextStyle(
                      fontSize: 64,
                      fontWeight: FontWeight.bold,
                      color: showHeads ? const Color(0xFF8B5A00) : const Color(0xFF424242),
                      shadows: const [
                        Shadow(color: Colors.white24, offset: Offset(1, 1), blurRadius: 1)
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