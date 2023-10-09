import 'package:flutter/material.dart';

class CatalogueFilmsScreen extends StatelessWidget {
  const CatalogueFilmsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: const Text('Films'),
      ),
      body: const Center(
        child: Text('Content of Films goes here.'),
      ),
    );
  }
}
