import 'package:flutter/material.dart';
import 'coin_flip_screen.dart';
import 'inventory_screen.dart';
import 'gacha_screen.dart';

class MainNavigationHub extends StatefulWidget {
  const MainNavigationHub({super.key});

  @override
  State<MainNavigationHub> createState() => _MainNavigationHubState();
}

class _MainNavigationHubState extends State<MainNavigationHub> {
  int _currentTabIndex = 0;

  // Lista delle schermate principali collegate ai rispettivi Tab
  final List<Widget> _screens = [
    const CoinFlipScreen(), 
    const InventoryScreen(),
    const GachaScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentTabIndex,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentTabIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _currentTabIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.casino_outlined),
            selectedIcon: Icon(Icons.casino),
            label: 'Lancio',
          ),
          NavigationDestination(
            icon: Icon(Icons.backpack_outlined),
            selectedIcon: Icon(Icons.backpack),
            label: 'Collezione',
          ),
          NavigationDestination(
            icon: Icon(Icons.stars_outlined),
            selectedIcon: Icon(Icons.stars),
            label: 'Gacha',
          ),
        ],
      ),
    );
  }
}