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
    final filmNameController = TextEditingController();
    final filmTypeController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Developing Note'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
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
                  'film_name': filmNameController.text,
                  'film_type': filmTypeController.text,
                  // Populate other fields accordingly
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
        child: const Icon(Icons.add),
        tooltip: 'Add Note',
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
