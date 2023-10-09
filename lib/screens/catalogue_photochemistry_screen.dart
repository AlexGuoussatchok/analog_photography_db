import 'package:flutter/material.dart';

class CataloguePhotochemistryScreen extends StatelessWidget {
  const CataloguePhotochemistryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: const Text('Photochemistry'),
      ),
      body: const Center(
        child: Text('Content of Photochemistry goes here.'),
      ),
    );
  }
}
