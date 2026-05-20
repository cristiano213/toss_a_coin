import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GachaScreen extends ConsumerWidget {
  const GachaScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tempio Gacha'),
        centerTitle: true,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.stars, size: 64, color: Colors.amber),
            SizedBox(height: 16),
            Text(
              'Simulatore Gacha',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('Pity Counter e pull a premi verranno implementati qui.'),
          ],
        ),
      ),
    );
  }
}