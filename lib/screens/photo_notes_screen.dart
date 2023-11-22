import 'package:flutter/material.dart';

class PhotoNotesScreen extends StatelessWidget {
  const PhotoNotesScreen({Key? key}) : super(key: key);

  void _onDevelopingNotesPressed() {
    // Logic for what happens when the 'My Film Developing Notes' button is pressed
    print("My Film Developing Notes button pressed");
  }

  void _onHistoryNotesPressed() {
    // Logic for what happens when the 'My Films History Notes' button is pressed
    print("My Films History Notes button pressed");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Photo Notes'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0), // Add padding around the buttons
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _onDevelopingNotesPressed,
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 64), // Make the button full width and double height
                textStyle: const TextStyle(fontSize: 20), // Increase font size
                padding: const EdgeInsets.symmetric(vertical: 16), // Increase padding inside the button
              ),
              child: const Text('My Film Developing Notes'),
            ),
            const SizedBox(height: 20), // Space between buttons
            ElevatedButton(
              onPressed: _onHistoryNotesPressed,
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 64), // Make the button full width and double height
                textStyle: const TextStyle(fontSize: 20), // Increase font size
                padding: const EdgeInsets.symmetric(vertical: 16), // Increase padding inside the button
              ),
              child: const Text('My Films History Notes'),
            ),
          ],
        ),
      ),
    );
  }
}
