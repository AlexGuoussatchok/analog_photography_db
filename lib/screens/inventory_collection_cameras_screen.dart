import 'package:flutter/material.dart';
import 'package:analog_photography_db/database_helpers/inventory_collection/cameras_database_helper.dart';
import 'package:analog_photography_db/models/inventory_camera.dart';
import 'package:analog_photography_db/widgets/collection/cameras_list_item.dart';

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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Camera Collection"),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: _cameras.length,
        itemBuilder: (context, index) {
          return CameraListItem(camera: _cameras[index]);
        },
      ),
    );
  }
}
