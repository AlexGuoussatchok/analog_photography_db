import 'package:flutter/material.dart';

class CatalogueFlashesScreen extends StatelessWidget {
  const CatalogueFlashesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: const Text('Flashes'),
      ),
      body: const Center(
        child: Text('Content of Flashes goes here.'),
      ),
    );
  }
}
