import 'package:flutter/material.dart';
import 'package:analog_photography_db/database_helpers/cameras_catalogue_database_helper.dart';

class CatalogueCamerasScreen extends StatefulWidget {
  const CatalogueCamerasScreen({Key? key}) : super(key: key);  // Corrected this line

  @override
  _CatalogueCamerasScreenState createState() => _CatalogueCamerasScreenState();
}

class _CatalogueCamerasScreenState extends State<CatalogueCamerasScreen> {
  List<String> cameraBrands = [];
  List<String> cameraModels = [];
  String? selectedBrand;

  @override
  void initState() {
    super.initState();
    _loadCameraBrands();
  }

  _loadCameraBrands() async {
    try {
      var brands = await CamerasCatalogueDatabaseHelper().getCameraBrands();
      setState(() {
        cameraBrands = brands.map((e) => e['brand'].toString()).toList();
      });
    } catch (e) {
      print(e);
    }
  }

  _loadCameraModels(String brand) async {
    try {
      String tableName = '${brand.toLowerCase()}_cameras_catalogue';
      var models = await CamerasCatalogueDatabaseHelper().getCameraModels(
          tableName);
      setState(() {
        cameraModels = models.map((e) => e['model'].toString()).toList();
      });
    } catch (e) {
      print(e);
    }
  }

  @override  // Corrected this annotation
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: const Text('Cameras Catalogue'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(
                  color: Colors.grey,
                  width: 2.0,
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  // to make it take the full width of the container
                  items: cameraBrands.map((String brand) {
                    return DropdownMenuItem<String>(
                      value: brand,
                      child: Text(brand),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedBrand = value!;
                      _loadCameraModels(selectedBrand!);
                    });
                  },
                  hint: const Text('Select a brand'),
                  value: selectedBrand,
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            // provides spacing between the dropdown and the list
            Expanded(
              child: ListView.builder(
                itemCount: cameraModels.length,
                itemBuilder: (context, index) {
                  return ListTile(title: Text(cameraModels[index]));
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
