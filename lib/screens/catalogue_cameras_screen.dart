import 'package:flutter/material.dart';
import 'package:analog_photography_db/database_helpers/cameras_catalogue_database_helper.dart';

class CatalogueCamerasScreen extends StatefulWidget {
  const CatalogueCamerasScreen({Key? key}) : super(key: key);

  @override
  _CatalogueCamerasScreenState createState() => _CatalogueCamerasScreenState();
}

class _CatalogueCamerasScreenState extends State<CatalogueCamerasScreen> {
  final CamerasCatalogueDatabaseHelper dbHelper = CamerasCatalogueDatabaseHelper();
  List<String> cameraBrands = [];

  @override
  void initState() {
    super.initState();
    _loadCameraBrands();
  }

  _loadCameraBrands() async {
    try {
      var brands = await dbHelper.getCameraBrands();
      setState(() {
        cameraBrands = brands.map((e) => e['brand'].toString()).toList();
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: const Text('Cameras'),
      ),
      body: cameraBrands.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: cameraBrands.length,
        itemBuilder: (context, index) {
          return ListTile(title: Text(cameraBrands[index]));
        },
      ),
    );
  }

  @override
  void dispose() {
    dbHelper.close();
    super.dispose();
  }
}

