import 'package:flutter/material.dart';

class CataloguePaperDryersScreen extends StatelessWidget {
  const CataloguePaperDryersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: const Text('Paper Dryers'),
      ),
      body: const Center(
        child: Text('Content of Paper Dryers goes here.'),
      ),
    );
  }
}
