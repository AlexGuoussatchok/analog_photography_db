import 'package:flutter/material.dart';
import 'package:analog_photography_db/database_helpers/inventory_collection/cameras_database_helper.dart';
import 'package:analog_photography_db/models/inventory_camera.dart';
import 'package:analog_photography_db/widgets/collection/cameras_list_item.dart';
import 'package:analog_photography_db/database_helpers/cameras_catalogue_database_helper.dart';
import 'package:analog_photography_db/lists/cameras_condition_list.dart';


class InventoryCollectionCamerasScreen extends StatefulWidget {
  const InventoryCollectionCamerasScreen({Key? key}) : super(key: key);

  @override
  _InventoryCollectionCamerasScreenState createState() => _InventoryCollectionCamerasScreenState();
}

class _InventoryCollectionCamerasScreenState extends State<InventoryCollectionCamerasScreen> {
  List<InventoryCamera> _cameras = [];
  final List<String> _cameraModels = [];
  String? _dialogSelectedBrand;
  List<String> _dialogCameraModels = [];
  bool _isLoading = true;
  DateTime selectedDate = DateTime.now();


  @override
  void initState() {
    super.initState();
    _loadCameras();
  }

  _loadCameras() async {
    var cameras = await CamerasDatabaseHelper.fetchCameras();

    if (mounted) {
      setState(() {
        _cameras = cameras;
        _isLoading = false;
      });
    }
  }


  Future<void> _updateCameraModels() async {
    if (_dialogSelectedBrand != null && _dialogSelectedBrand!.isNotEmpty) {
      final modelsData = await CamerasCatalogueDatabaseHelper().getCameraModelsByBrand(_dialogSelectedBrand!);

      setState(() {
        _dialogCameraModels = modelsData.map((item) => item['model'] as String).toList();
      });
    } else {
      setState(() {
        _dialogCameraModels = [];
      });
    }
  }



  void _showAddCameraDialog(BuildContext context) async {
    final List<Map<String, dynamic>> brandList = await CamerasCatalogueDatabaseHelper().getCameraBrands();
    final List<String> brandNames = brandList.map((e) => e['brand'] as String).toList();

    String? dialogSelectedBrand;
    List<String> dialogCameraModels = [];

    final modelController = TextEditingController();
    final serialNumberController = TextEditingController();
    final purchaseDateController = TextEditingController();
    final pricePaidController = TextEditingController();
    final conditionController = TextEditingController();
    final filmLoadDateController = TextEditingController();
    final filmLoadedController = TextEditingController();
    final averagePriceController = TextEditingController();
    final commentsController = TextEditingController();

    Future<void> updateCameraModels(StateSetter setState) async {
      if (dialogSelectedBrand != null && dialogSelectedBrand!.isNotEmpty) {
        final camerasCatalogueDbHelper = CamerasCatalogueDatabaseHelper();
        final modelsData = await camerasCatalogueDbHelper.getCameraModelsByBrand(dialogSelectedBrand!.toLowerCase());

        setState(() {
          dialogCameraModels = modelsData.map((item) => item['model'] as String).toList();
          modelController.text = ''; // or set it to null or an initial value if required
        });
      } else {
        setState(() {
          dialogCameraModels = [];
        });
      }
    }

    Future<void> selectDate(BuildContext context) async {
      DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1900),
        lastDate: DateTime(2222),
      );
      if (pickedDate != null && pickedDate != selectedDate)
        setState(() {
          selectedDate = pickedDate;
          purchaseDateController.text = "${selectedDate.toLocal()}".split(' ')[0]; // formats it to yyyy-mm-dd
        });
    }

    Future<void> selectFilmLoadedDate(BuildContext context) async {
      DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime.now(),
      );

      if (pickedDate != null) {
        setState(() {
          filmLoadDateController.text = '${pickedDate.toLocal()}'.split(' ')[0];
        });
      }
    }



    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add New Camera'),
          content: SingleChildScrollView(
            child: StatefulBuilder(
              builder: (BuildContext context, StateSetter dialogSetState) {
                return Column(
                  children: [
                    DropdownButtonFormField<String>(
                      value: dialogSelectedBrand,
                      items: brandNames.map((String brand) {
                        return DropdownMenuItem<String>(
                          value: brand,
                          child: Text(brand),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        dialogSetState(() {
                          dialogSelectedBrand = newValue;
                          modelController.text = '';  // Clear the model when brand changes.
                        });
                        updateCameraModels(dialogSetState);  // Passing the StateSetter to updateCameraModels function
                      },
                      decoration: const InputDecoration(labelText: 'Brand'),
                    ),
                    DropdownButtonFormField<String>(
                      value: modelController.text.isNotEmpty ? modelController.text : null,  // Use the value of modelController for the dropdown value.
                      items: dialogCameraModels.map((String model) {
                        return DropdownMenuItem<String>(
                          value: model,
                          child: Text(model),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        dialogSetState(() {
                          modelController.text = newValue!;
                        });
                      },
                      decoration: const InputDecoration(labelText: 'Model'),
                    ),

                    TextField(
                      controller: serialNumberController,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(labelText: 'Serial Number'),
                    ),

                    TextField(
                      controller: purchaseDateController,
                      readOnly: true,  // Makes the text field read-only, so it's not editable
                      decoration: const InputDecoration(labelText: 'Purchase Date'),
                      onTap: () {
                        selectDate(context);
                      },
                    ),

                    TextField(
                      controller: pricePaidController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),  // Ensures numeric keyboard layout
                      decoration: const InputDecoration(
                        labelText: 'Price Paid',
                        suffixText: '€',  // Display Euro sign at the end
                      ),
                    ),


                    DropdownButtonFormField<String>(
                      value: conditionController.text.isEmpty ? null : conditionController.text,
                      items: cameraConditions.map((String condition) {
                        return DropdownMenuItem<String>(
                          value: condition,
                          child: Text(condition),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          conditionController.text = newValue!;
                        });
                      },
                      decoration: const InputDecoration(labelText: 'Condition'),
                    ),

                    TextField(
                      controller: filmLoadDateController,
                      readOnly: true,
                      decoration: const InputDecoration(labelText: 'Film Load Date'),
                      onTap: () {
                        selectFilmLoadedDate(context);
                      },
                    ),

                    TextField(
                      controller: filmLoadedController,
                      decoration: const InputDecoration(labelText: 'Film Loaded'),
                    ),

                    TextField(
                      controller: averagePriceController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),  // Ensures numeric keyboard layout
                      decoration: const InputDecoration(
                        labelText: 'Average Price',
                        suffixText: '€',  // Display Euro sign at the end
                      ),
                    ),

                    TextField(
                      controller: commentsController,
                      decoration: const InputDecoration(labelText: 'Comments'),
                    ),
                  ],
                );
              },
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
                double? pricePaid = double.tryParse(pricePaidController.text);
                double? averagePrice = double.tryParse(averagePriceController.text);

                final newCamera = InventoryCamera(
                  brand: dialogSelectedBrand!,
                  model: modelController.text,
                  serialNumber: serialNumberController.text,
                  purchaseDate: DateTime.tryParse(purchaseDateController.text),
                  pricePaid: pricePaid,
                  condition: conditionController.text,
                  filmLoadDate: DateTime.tryParse(filmLoadDateController.text),
                  filmLoaded: filmLoadedController.text,
                  averagePrice: averagePrice,
                  comments: commentsController.text,
                );

                await CamerasDatabaseHelper.insertCamera(newCamera);
                _loadCameras();

                Navigator.of(context).pop();
              },
              child: const Text('Add'),
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
        automaticallyImplyLeading: false,
        title: const Text("Camera Collection"),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: _cameras.length,
        itemBuilder: (context, index) {
          return CameraListItem(camera: _cameras[index]);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddCameraDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
