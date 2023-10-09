import 'package:flutter/material.dart';

class CatalogueLensesScreen extends StatelessWidget {
  const CatalogueLensesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: const Text('Lenses'),
      ),
      body: const Center(
        child: Text('Content of Lenses goes here.'),
      ),
    );
  }
}
