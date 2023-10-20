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

    String? isExpiredValue;

    int daysDifference(DateTime date1, DateTime date2) {
      return date1.difference(date2).inDays;
    }

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
                        labelText: selectedExpirationOption == null ? 'Film Expiration Date' : null,
                        hintText: selectedExpirationOption == null ? null : 'Film Expiration Date',
                      ),
                      isEmpty: selectedExpirationOption == null,  // to determine if the dropdown is empty or not
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<ExpirationOption>(
                          value: selectedExpirationOption,
                          isDense: true,
                          onChanged: (ExpirationOption? newValue) async {
                            if (newValue == ExpirationOption.datePicker) {
                              DateTime? date = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1900),
                                lastDate: DateTime(2101),
                              );
                              if (date != null) {
                                selectedDate = date;
                                expirationDateController.text = DateFormat('yyyy-MM-dd').format(date);
                                if (date.isBefore(DateTime.now())) {
                                  isExpiredValue = "Film Expired";
                                } else {
                                  isExpiredValue = "Not Expired (days left: ${daysDifference(date, DateTime.now())})";
                                }
                              }
                            } else {
                              selectedDate = null;
                              isExpiredValue = "Unknown";
                            }
                            dialogSetState(() {});
                          },
                          items: const <DropdownMenuItem<ExpirationOption>>[
                            DropdownMenuItem<ExpirationOption>(
                              value: ExpirationOption.unknown,
                              child: Text('Unknown'),
                            ),
                            DropdownMenuItem<ExpirationOption>(
                              value: ExpirationOption.datePicker,
                              child: Text('Select Date'),
                            ),
                          ],
                        ),
                      ),
                    ),

                    InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'Is Expired?',
                        contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                      ),
                      child: Text(isExpiredValue ?? ''),
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
                      isExpired: isExpiredValue,
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
