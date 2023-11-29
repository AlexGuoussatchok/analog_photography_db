import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:analog_photography_db/database_helpers/my_notes_database_helper.dart';
import 'package:analog_photography_db/database_helpers/inventory_collection/films_database_helper.dart';
import 'package:analog_photography_db/database_helpers/inventory_collection/cameras_database_helper.dart';


class DevelopingNotesScreen extends StatefulWidget {
  const DevelopingNotesScreen({super.key});

  @override
  _DevelopingNotesScreenState createState() => _DevelopingNotesScreenState();
}

class _DevelopingNotesScreenState extends State<DevelopingNotesScreen> {
  late Future<List<Map<String, dynamic>>> _notesFuture;
  List<String> filmNames = [];
  List<Map<String, dynamic>> cameraDropdownItems = [];
  String? selectedCamera;

  @override
  void initState() {
    super.initState();
    _notesFuture = MyNotesDatabaseHelper().getDevelopingNotes();
    _loadFilmNames(); // Load film names when the screen is initialized
    _notesFuture = MyNotesDatabaseHelper().getDevelopingNotes();
    _loadCameras();
  }

  Future<void> _loadFilmNames() async {
    // Fetch film names from the database and update filmNames list
    filmNames = await FilmsDatabaseHelper.getFilmNamesForDropdown();
    setState(() {}); // Update the state to reflect the new data
  }

  Future<void> _loadCameras() async {
    cameraDropdownItems = await CamerasDatabaseHelper().getCamerasForDropdown();
    setState(() {}); // Refresh the UI with the loaded data
  }

  Future<void> _showAddNoteDialog(BuildContext context) async {
    final dateController = TextEditingController(text: DateFormat('yyyy-MM-dd').format(DateTime.now()));
    final maxFilmNumber = await MyNotesDatabaseHelper().getMaxFilmNumber();
    final filmNumberController = TextEditingController(text: '${maxFilmNumber + 1}');
    final filmNameController = TextEditingController();
    final filmTypeController = TextEditingController();
    final filmSizeController = TextEditingController();
    final filmISOController = TextEditingController();
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

    String? selectedFilmName;

    Future<void> _selectDate(BuildContext context) async {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1965),
        lastDate: DateTime(2055),
      );
      if (picked != null && picked != DateTime.now()) {
        setState(() {
          dateController.text = DateFormat('yyyy-MM-dd').format(picked);
        });
      }
    }


    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Developing Note'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                InkWell(
                  onTap: () => _selectDate(context),
                  child: IgnorePointer(
                    child: TextField(
                      controller: dateController,
                      decoration: const InputDecoration(
                        labelText: 'Date',
                      ),
                    ),
                  ),
                ),
                TextField(
                  controller: filmNumberController,
                  decoration: const InputDecoration(
                    labelText: 'Film Number',
                  ),
                  keyboardType: TextInputType.number, // Set the keyboard type to numeric
                ),
                DropdownButtonFormField<String>(
                  value: selectedFilmName,
                  decoration: const InputDecoration(labelText: 'Select Film Name'),
                  onChanged: (String? newValue) async {
                    setState(() {
                      selectedFilmName = newValue;
                    });
                    if (newValue != null) {
                      var parts = newValue.split(' ');
                      var brand = parts[0];
                      var name = parts.sublist(1).join(' ');

                      // Fetch film details
                      var filmDetails = await FilmsDatabaseHelper.getFilmDetails(brand, name);

                      // Update other fields
                      setState(() {
                        filmTypeController.text = filmDetails['filmType'] ?? '';
                        filmSizeController.text = filmDetails['filmSize'] ?? '';
                        filmISOController.text = filmDetails['iso'] ?? '';
                        filmExpiredController.text = filmDetails['filmExpired'] ?? '';
                        filmExpDateController.text = filmDetails['filmExpDate'] ?? '';
                        // Update other fields as needed
                      });
                    }
                  },

                  items: filmNames.map<DropdownMenuItem<String>>((String name) {
                    return DropdownMenuItem<String>(
                      value: name,
                      child: Text(name),
                    );
                  }).toList(),
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
                  controller: filmISOController,
                  decoration: const InputDecoration(
                    labelText: 'ISO',
                  ),
                  keyboardType: TextInputType.number,
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
                  keyboardType: TextInputType.number,
                ),
                DropdownButtonFormField<String>(
                  value: selectedCamera,
                  decoration: const InputDecoration(labelText: 'Select Camera'),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedCamera = newValue;
                      // Handle other field updates based on the selected camera
                    });
                  },
                  items: cameraDropdownItems.map<DropdownMenuItem<String>>((Map<String, dynamic> item) {
                    return DropdownMenuItem<String>(
                      value: item['displayValue'],
                      child: Text(item['displayValue']),
                    );
                  }).toList(),
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
                  'iso': filmISOController.text,
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
