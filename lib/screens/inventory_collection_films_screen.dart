import 'package:flutter/material.dart';
import 'package:analog_photography_db/database_helpers/inventory_collection/films_database_helper.dart';
import 'package:analog_photography_db/models/inventory_films.dart';
import 'package:analog_photography_db/widgets/collection/films_list_item.dart';
import 'package:analog_photography_db/database_helpers/films_catalogue_database_helper.dart';
import 'package:intl/intl.dart';

enum ExpirationOption { unknown, datePicker }



class InventoryCollectionFilmsScreen extends StatefulWidget {
  const InventoryCollectionFilmsScreen({Key? key}) : super(key: key);

  @override
  _InventoryCollectionFilmsScreenState createState() => _InventoryCollectionFilmsScreenState();
}

class _InventoryCollectionFilmsScreenState extends State<InventoryCollectionFilmsScreen> {
  List<InventoryFilms> _films = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFilms();
  }

  Future<void> _loadFilms() async {
    var films = await FilmsDatabaseHelper.fetchFilms();
    if (mounted) {
      setState(() {
        _films = films;
        _isLoading = false;
      });
    }
  }

  void _showAddFilmsDialog(BuildContext context) async {
    final List<Map<String, dynamic>> brandList = await FilmsCatalogueDatabaseHelper().getFilmsBrands();
    final List<String> brandNames = brandList.map((e) => e['brand'] as String).toList();

    String? dialogSelectedBrand;
    List<String> dialogFilmsNames = [];

    ExpirationOption? selectedExpirationOption;
    DateTime? selectedDate;


    final brandController = TextEditingController();
    final namesController = TextEditingController();
    final typeController = TextEditingController();
    final sizeTypeController = TextEditingController();
    final isoController = TextEditingController();
    final expirationDateController = TextEditingController();
    final isExpiredController = TextEditingController();
    final quantityController = TextEditingController();
    final averagePriceController = TextEditingController();
    final commentsController = TextEditingController();

    Future<void> updateFilmsNames(StateSetter setState) async {
      if (dialogSelectedBrand != null && dialogSelectedBrand!.isNotEmpty) {
        final namesData = await FilmsCatalogueDatabaseHelper().getFilmsNamesByBrand(dialogSelectedBrand!);
        setState(() {
          dialogFilmsNames = namesData.map((item) => item['name'] as String).toList();
          namesController.text = ''; // reset the selected film name when changing brands
        });
      } else {
        setState(() {
          dialogFilmsNames = [];
        });
      }
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter dialogSetState) {
            Future<void> populateFilmDetails(String brand, String filmName) async {
              final filmDetails = await FilmsCatalogueDatabaseHelper()
                  .getFilmDetailsByBrandAndName(brand, filmName);

              if (filmDetails != null && filmDetails.isNotEmpty) {
                dialogSetState(() {
                  typeController.text = filmDetails['type'] ?? '';       // Corresponds to 'Type of film'
                  sizeTypeController.text = filmDetails['size_type'] ?? ''; // Corresponds to 'Size Type'
                  isoController.text = filmDetails['speed'] ?? '';      // Corresponds to 'ISO'
                  // If there are other fields to populate, add them here.
                });
              }
            }

            return AlertDialog(
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    // Brand Dropdown
                    InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Select a brand',
                        contentPadding: EdgeInsets.all(0),
                      ),
                      isEmpty: brandController.text.isEmpty,
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: brandController.text.isEmpty ? null : brandController.text,
                          items: brandNames.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            dialogSetState(() {
                              brandController.text = newValue!;
                              dialogSelectedBrand = newValue;
                              updateFilmsNames(dialogSetState); // fetch the film names for the selected brand
                            });
                          },
                        ),
                      ),
                    ),

                    // Film Name Dropdown
                    InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Select a film name',
                        contentPadding: EdgeInsets.all(0),
                      ),
                      isEmpty: namesController.text.isEmpty,
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: namesController.text.isEmpty ? null : namesController.text,
                          items: dialogFilmsNames.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            dialogSetState(() {
                              namesController.text = newValue!;
                              if (dialogSelectedBrand != null && newValue != null) {
                                populateFilmDetails(dialogSelectedBrand!, newValue);
                              }
                            });
                          },
                        ),
                      ),
                    ),
                    TextField(
                      controller: typeController,
                      decoration: const InputDecoration(labelText: 'Type of Film'),
                    ),
                    TextField(
                      controller: sizeTypeController,
                      decoration: const InputDecoration(labelText: 'Size Type'),
                    ),
                    TextField(
                      controller: isoController,
                      decoration: const InputDecoration(labelText: 'ISO'),
                    ),

                    InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'Film Expiration Date',
                      ),
                      isEmpty: selectedExpirationOption == null,
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<ExpirationOption>(
                          value: selectedExpirationOption,
                          items: [
                            DropdownMenuItem(
                              value: ExpirationOption.unknown,
                              child: Text('Unknown'),
                            ),
                            DropdownMenuItem(
                              value: ExpirationOption.datePicker,
                              child: Text(expirationDateController.text.isEmpty ? 'Select Date' : expirationDateController.text),
                            ),
                          ],
                          onChanged: (ExpirationOption? newValue) async {
                            if (newValue == ExpirationOption.datePicker) {
                              DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: selectedDate ?? DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2101),
                              );
                              if (pickedDate != null) {
                                selectedDate = pickedDate;
                                expirationDateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
                              }
                            } else {
                              selectedDate = null; // Clear the selected date when 'Unknown' is picked
                              expirationDateController.text = ''; // Clear the displayed date
                            }
                            dialogSetState(() {
                              selectedExpirationOption = newValue!;
                            });
                          },
                        ),
                      ),
                    ),

                    TextField(
                      controller: isExpiredController,
                      decoration: const InputDecoration(labelText: 'Is Expired?'),
                    ),
                    TextField(
                      controller: quantityController,
                      decoration: const InputDecoration(labelText: 'Quantity'),
                    ),
                    TextField(
                      controller: averagePriceController,
                      decoration: const InputDecoration(labelText: 'Average Price'),
                    ),
                    TextField(
                      controller: commentsController,
                      decoration: const InputDecoration(labelText: 'Comments'),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () async {
                    int? quantity = int.tryParse(quantityController.text);
                    double? averagePrice = double.tryParse(averagePriceController.text);
                    if (dialogSelectedBrand == null || dialogSelectedBrand!.isEmpty) {
                      // Handle error
                      return;
                    }
                    final newFilms = InventoryFilms(
                      brand: dialogSelectedBrand!,
                      name: namesController.text,
                      type: typeController.text,
                      sizeType: sizeTypeController.text,
                      expirationDate: DateTime.tryParse(expirationDateController.text),
                      isExpired: isExpiredController.text,
                      quantity: quantity,
                      averagePrice: averagePrice,
                      comments: commentsController.text,
                    );
                    await FilmsDatabaseHelper.insertFilms(newFilms);
                    _loadFilms();
                    Navigator.of(context).pop();
                  },
                  child: const Text('Add'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Films Collection"),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: _films.length,
        itemBuilder: (context, index) {
          return FilmsListItem(films: _films[index]);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddFilmsDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
