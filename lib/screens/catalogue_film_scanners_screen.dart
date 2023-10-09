import 'package:flutter/material.dart';

class CatalogueFilmScannersScreen extends StatelessWidget {
  const CatalogueFilmScannersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: const Text('Film Scanners'),
      ),
      body: const Center(
        child: Text('Content of Film Scanners goes here.'),
      ),
    );
  }
}
