import 'package:flutter/material.dart';

class CatalogueExposureMetersScreen extends StatelessWidget {
  const CatalogueExposureMetersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: const Text('Exposure / Flash meters'),
      ),
      body: const Center(
        child: Text('Content of Exposure / Flash meters goes here.'),
      ),
    );
  }
}
