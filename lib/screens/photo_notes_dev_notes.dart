import 'package:flutter/material.dart';
import 'package:analog_photography_db/database_helpers/my_notes_database_helper.dart';

class DevelopingNotesScreen extends StatefulWidget {
  const DevelopingNotesScreen({super.key});

  @override
  _DevelopingNotesScreenState createState() => _DevelopingNotesScreenState();
}

class _DevelopingNotesScreenState extends State<DevelopingNotesScreen> {
  late Future<List<Map<String, dynamic>>> _notesFuture;

  @override
  void initState() {
    super.initState();
    _notesFuture = MyNotesDatabaseHelper().getDevelopingNotes();
  }

  void _showAddNoteDialog(BuildContext context) {
    final dateController = TextEditingController();
    final filmNumberController = TextEditingController();
    final filmNameController = TextEditingController();
    final filmTypeController = TextEditingController();
    final filmSizeController = TextEditingController();
    final filmExpiredController = TextEditingController();
    final filmExpDateController = TextEditingController();
    final cameraController = TextEditingController();
    final lensesController = TextEditingController();
    final developerController = TextEditingController();
    final labController = TextEditingController();
    final dilutionController = TextEditingController();
    final devTimeController = TextEditingController();
    final temperatureController = TextEditingController();
    final commentsController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Developing Note'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextField(
                  controller: dateController,
                  decoration: const InputDecoration(
                    labelText: 'Date',
                  ),
                ),
                TextField(
                  controller: filmNumberController,
                  decoration: const InputDecoration(
                    labelText: 'Film Number',
                  ),
                ),
                TextField(
                  controller: filmNameController,
                  decoration: const InputDecoration(
                    labelText: 'Film Name',
                  ),
                ),
                TextField(
                  controller: filmTypeController,
                  decoration: const InputDecoration(
                    labelText: 'Film Type',
                  ),
                ),
                TextField(
                  controller: filmSizeController,
                  decoration: const InputDecoration(
                    labelText: 'Film Size',
                  ),
                ),
                TextField(
                  controller: filmExpiredController,
                  decoration: const InputDecoration(
                    labelText: 'Film Expired?',
                  ),
                ),
                TextField(
                  controller: filmExpDateController,
                  decoration: const InputDecoration(
                    labelText: 'Film Expiration Date',
                  ),
                ),
                TextField(
                  controller: cameraController,
                  decoration: const InputDecoration(
                    labelText: 'Camera',
                  ),
                ),
                TextField(
                  controller: lensesController,
                  decoration: const InputDecoration(
                    labelText: 'Lenses',
                  ),
                ),
                TextField(
                  controller: developerController,
                  decoration: const InputDecoration(
                    labelText: 'Developer',
                  ),
                ),
                TextField(
                  controller: labController,
                  decoration: const InputDecoration(
                    labelText: 'Lab',
                  ),
                ),
                TextField(
                  controller: dilutionController,
                  decoration: const InputDecoration(
                    labelText: 'Dilution',
                  ),
                ),
                TextField(
                  controller: devTimeController,
                  decoration: const InputDecoration(
                    labelText: 'Dev Time',
                  ),
                ),
                TextField(
                  controller: temperatureController,
                  decoration: const InputDecoration(
                    labelText: 'Temperature',
                  ),
                ),
                TextField(
                  controller: commentsController,
                  decoration: const InputDecoration(
                    labelText: 'Comments',
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Add'),
              onPressed: () async {
                await MyNotesDatabaseHelper().insertDevelopingNote({
                  'date': dateController.text,
                  'film_number': filmNumberController.text,
                  'film_name': filmNameController.text,
                  'film_type': filmTypeController.text,
                  'film_size': filmSizeController.text,
                  'film_expired': filmExpiredController.text,
                  'film_exp_date': filmExpDateController.text,
                  'camera': cameraController.text,
                  'lenses': lensesController.text,
                  'developer': developerController.text,
                  'lab': labController.text,
                  'dilution': dilutionController.text,
                  'dev_time': devTimeController.text,
                  'temp': temperatureController.text,
                  'comments': commentsController.text,
                });
                setState(() {
                  _notesFuture = MyNotesDatabaseHelper().getDevelopingNotes();
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Developing Notes'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddNoteDialog(context),
        tooltip: 'Add Note',
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _notesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var note = snapshot.data![index];
                // Customize how you display each note here
                return ListTile(
                  title: Text(note['film_name'] ?? 'Unknown'),
                  // Add more details as needed
                );
              },
            );
          } else {
            return const Center(child: Text('No notes found'));
          }
        },
      ),
    );
  }
}
