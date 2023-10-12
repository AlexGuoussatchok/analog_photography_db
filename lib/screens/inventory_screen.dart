import 'package:flutter/material.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({Key? key}) : super(key: key);

  @override
  _InventoryScreenState createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen>
    with TickerProviderStateMixin {
  late TabController _firstTabController;
  late TabController _secondTabController;

  @override
  void initState() {
    super.initState();
    _firstTabController = TabController(length: 4, vsync: this);
    _secondTabController = TabController(length: 14, vsync: this);
  }

  @override
  void dispose() {
    _firstTabController.dispose();
    _secondTabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Inventory'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(120.0),
          child: Column(
            children: [
              const SizedBox(height: 10.0),
              const Divider(height: 1.0, thickness: 3.0, color: Colors.white),
              Container(
                color: Colors.white,
                child: TabBar(
                  controller: _firstTabController,
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.grey,
                  indicatorSize: TabBarIndicatorSize.label,
                  indicator: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(5),
                  ),
                  tabs: [
                    Tab(text: 'Collection'),
                    Tab(text: 'Wishlist'),
                    Tab(text: 'Sell-list'),
                    Tab(text: 'Borrowed'),
                  ],
                ),
              ),
              const SizedBox(height: 10.0),
              const Divider(height: 1.0, thickness: 3.0, color: Colors.white),
              Container(
                color: Colors.white,
                child: TabBar(
                  controller: _secondTabController,
                  isScrollable: true,
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.grey,
                  indicatorSize: TabBarIndicatorSize.label,
                  indicator: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(5),
                  ),
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
              ),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _firstTabController,
        children: [
          ...List.generate(4, (index) => const Center(child: Text('Content for selected tab.'))),
        ],
      ),
    );
  }
}
