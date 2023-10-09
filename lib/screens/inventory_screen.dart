import 'package:flutter/material.dart';

class InventoryScreen extends StatelessWidget {
  const InventoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Inventory'),
      ),
      body: const Center(
        child: Text('My Inventory goes here.'),
      ),
    );
  }
}
