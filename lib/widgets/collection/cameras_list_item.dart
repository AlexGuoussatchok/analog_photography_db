import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:analog_photography_db/models/inventory_camera.dart';

class CameraListItem extends StatelessWidget {
  final InventoryCamera camera;

  const CameraListItem({super.key, required this.camera});

  void _showCameraDetails(BuildContext context, InventoryCamera camera) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("${camera.brand} ${camera.model}"),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Text('Serial Number: ${camera.serialNumber}'),
                if (camera.purchaseDate != null) Text('Purchase Date: ${DateFormat('yyyy-MM-dd').format(camera.purchaseDate!)}'),
                if (camera.pricePaid != null) Text('Price Paid: \$${camera.pricePaid}'),
                Text('Condition: ${camera.condition}'),
                if (camera.filmLoadDate != null) Text('Film Load Date: ${DateFormat('yyyy-MM-dd').format(camera.filmLoadDate!)}'),
                if (camera.filmLoaded != null) Text('Film Loaded: ${camera.filmLoaded}'),
                if (camera.averagePrice != null) Text('Average Price: \$${camera.averagePrice}'),
                if (camera.comments != null && camera.comments!.isNotEmpty) Text('Comments: ${camera.comments}'),
                // ... add other fields as needed
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Close'),
              onPressed: () {
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
    return ListTile(
      title: Text("${camera.brand} ${camera.model}"),
      subtitle: Text('Serial: ${camera.serialNumber}'),
      onTap: () {
        _showCameraDetails(context, camera);
      },
    );
  }
}
