import 'package:flutter/material.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({Key? key}) : super(key: key);

  @override
  _InventoryScreenState createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _secondTabController;

  @override
  void initState() {
    super.initState();
    _secondTabController = TabController(length: 14, vsync: this);
  }

  @override
  void dispose() {
    _secondTabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4, // Control the first TabBar
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Inventory'),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(111.0),
            child: Column(
              children: [
                const SizedBox(height: 10.0),
                const Divider(height: 1.0, thickness: 1.0, color: Colors.white),
                const TabBar(
                  tabs: [
                    Tab(text: 'In Collection'),
                    Tab(text: 'Wishlist'),
                    Tab(text: 'Sell-list'),
                    Tab(text: 'Borrowed'),
                  ],
                ),
                const SizedBox(height: 10.0),
                const Divider(height: 1.0, thickness: 1.0, color: Colors.white),
                TabBar(
                  controller: _secondTabController,
                  isScrollable: true,
                  tabs: const [
                    Tab(text: 'Cameras'),
                    Tab(text: 'Lenses'),
                    Tab(text: 'Flashes'),
                    Tab(text: 'Exposure meters'),
                    Tab(text: 'Films'),
                    Tab(text: 'Filters'),
                    Tab(text: 'Photo papers'),
                    Tab(text: 'Enlargers'),
                    Tab(text: 'Color Analysers'),
                    Tab(text: 'Film Processors'),
                    Tab(text: 'Papers Dryers'),
                    Tab(text: 'Print Washers'),
                    Tab(text: 'Film Scanners'),
                    Tab(text: 'Photochemistry'),
                  ],
                ),
              ],
            ),
          ),
        ),
        body: TabBarView(
          children: [
            ...List.generate(4, (index) => const Center(child: Text('Content for selected tab.'))),
          ],
        ),
      ),
    );
  }
}
