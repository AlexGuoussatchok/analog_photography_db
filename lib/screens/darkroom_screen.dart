import 'package:flutter/material.dart';

class DarkroomScreen extends StatelessWidget {
  const DarkroomScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Darkroom'),
      ),
      body: const Center(
        child: Text('Darkroom here.'),
      ),
    );
  }
}
