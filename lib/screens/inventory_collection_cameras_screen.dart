import 'package:flutter/material.dart';
import 'package:analog_photography_db/database_helpers/inventory_collection/cameras_database_helper.dart';
import 'package:analog_photography_db/models/inventory_camera.dart';
import 'package:analog_photography_db/widgets/collection/cameras_list_item.dart';
import 'package:analog_photography_db/database_helpers/cameras_catalogue_database_helper.dart';

class InventoryCollectionCamerasScreen extends StatefulWidget {
  const InventoryCollectionCamerasScreen({super.key});

  @override
  _InventoryCollectionCamerasScreenState createState() => _InventoryCollectionCamerasScreenState();
}

class _InventoryCollectionCamerasScreenState extends State<InventoryCollectionCamerasScreen> {
  List<InventoryCamera> _cameras = [];

  bool _isLoading = true;


  @override
  void initState() {
    super.initState();
    _loadCameras();
  }

  _loadCameras() async {
    var cameras = await CamerasDatabaseHelper.fetchCameras();
    setState(() {
      _cameras = cameras;
      _isLoading = false;
    });
  }

  void _showAddCameraDialog(BuildContext context) async {
    final List<Map<String, dynamic>> brandList = await CamerasCatalogueDatabaseHelper().getCameraBrands();
    final List<String> brandNames = brandList.map((e) => e['brand'] as String).toList();

    String? selectedBrand;

    final TextEditingController modelController = TextEditingController();
    final TextEditingController serialNumberController = TextEditingController();
    final TextEditingController purchaseDateController = TextEditingController();
    final TextEditingController pricePaidController = TextEditingController();
    final TextEditingController conditionController = TextEditingController();
    final TextEditingController filmLoadDateController = TextEditingController();
    final TextEditingController filmLoadedController = TextEditingController();
    final TextEditingController averagePriceController = TextEditingController();
    final TextEditingController commentsController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add New Camera'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                DropdownButtonFormField<String>(
                  value: selectedBrand,
                  items: brandNames.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    selectedBrand = newValue!;
                  },
                  decoration: const InputDecoration(labelText: 'Brand'),
                ),
                TextField(
                  controller: modelController,
                  decoration: const InputDecoration(labelText: 'Model'),
                ),
                TextField(
                  controller: serialNumberController,
                  decoration: const InputDecoration(labelText: 'Serial Number'),
                ),
                TextField(
                  controller: purchaseDateController,
                  decoration: const InputDecoration(labelText: 'Purchase Date'),
                ),
                TextField(
                  controller: pricePaidController,
                  decoration: const InputDecoration(labelText: 'Price Paid'),
                ),
                TextField(
                  controller: conditionController,
                  decoration: const InputDecoration(labelText: 'Condition'),
                ),
                TextField(
                  controller: filmLoadDateController,
                  decoration: const InputDecoration(labelText: 'Film Load Date'),
                ),
                TextField(
                  controller: filmLoadedController,
                  decoration: const InputDecoration(labelText: 'Film Loaded'),
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
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                double? pricePaid = double.tryParse(pricePaidController.text);
                double? averagePrice = double.tryParse(averagePriceController.text);

                final newCamera = InventoryCamera(
                  brand: selectedBrand!,
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
                // _loadCameras(); // Refresh the camera list

                Navigator.of(context).pop(); // Close the dialog
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
