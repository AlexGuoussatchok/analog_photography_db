import 'package:flutter/material.dart';

class CatalogueFiltersScreen extends StatelessWidget {
  const CatalogueFiltersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: const Text('Filters'),
      ),
      body: const Center(
        child: Text('Content of Filters goes here.'),
      ),
    );
  }
}
