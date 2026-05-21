import 'package:flutter/material.dart';
import 'archive_page.dart';
import 'inventory_page.dart';

/// Hub screen managing the collection sub-views using a native Material 3 TabBar.
class CollectionHubScreen extends StatelessWidget {
  const CollectionHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Skin Collection'),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.auto_awesome_motion), text: 'Archivio Wiki'),
              Tab(icon: Icon(Icons.backpack), text: 'Equipaggiamento'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            ArchivePage(),
            InventoryPage(),
          ],
        ),
      ),
    );
  }
}