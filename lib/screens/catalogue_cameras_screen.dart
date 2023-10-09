import 'package:flutter/material.dart';

class CatalogueCamerasScreen extends StatelessWidget {
  const CatalogueCamerasScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: const Text('Cameras'),
      ),
      body: const Center(
        child: Text('Content of Cameras goes here.'),
      ),
    );
  }
}
