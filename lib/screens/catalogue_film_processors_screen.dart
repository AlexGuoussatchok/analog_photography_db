import 'package:flutter/material.dart';

class CatalogueFilmProcessorsScreen extends StatelessWidget {
  const CatalogueFilmProcessorsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: const Text('Film Processors'),
      ),
      body: const Center(
        child: Text('Content of Film Processors goes here.'),
      ),
    );
  }
}
