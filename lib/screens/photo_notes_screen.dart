import 'package:flutter/material.dart';

class PhotoNotesScreen extends StatelessWidget {
  const PhotoNotesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Photo notes'),
      ),
      body: const Center(
        child: Text('Photo notes here.'),
      ),
    );
  }
}
