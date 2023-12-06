import 'package:flutter/material.dart';
import 'package:analog_photography_db/database_helpers/inventory_collection/chemicals_database_helper.dart';
import 'package:analog_photography_db/models/inventory_chemicals.dart';
import 'package:analog_photography_db/database_helpers/chemicals_catalogue_database_helper.dart';

class InventoryCollectionPhotochemistryScreen extends StatefulWidget {
  const InventoryCollectionPhotochemistryScreen({Key? key}) : super(key: key);

  @override
  _InventoryCollectionPhotochemistryScreenState createState() => _InventoryCollectionPhotochemistryScreenState();
}

class _InventoryCollectionPhotochemistryScreenState extends State<InventoryCollectionPhotochemistryScreen> {
  List<InventoryChemicals> _chemicals = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadChemicals();
  }

  _loadChemicals() async {
    var chemicals = await ChemicalsDatabaseHelper.fetchChemicals();

    if (mounted) {
      setState(() {
        _chemicals = chemicals;
        _isLoading = false;
      });
    }
  }

  void _showAddChemicalsDialog(BuildContext context) async {
    final chemicalsList = await ChemicalsCatalogueDatabaseHelper().fetchChemicalsList();
    String? selectedChemical;
    final typeController = TextEditingController();
    final pricePaidController = TextEditingController();
    final conditionController = TextEditingController();
    final averagePriceController = TextEditingController();
    final commentsController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add New Photochemical'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                DropdownButtonFormField<String>(
                  value: selectedChemical,
                  onChanged: (newValue) => selectedChemical = newValue,
                  items: chemicalsList.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  decoration: const InputDecoration(labelText: 'Chemical'),
                ),
                TextField(
                  controller: typeController,
                  decoration: const InputDecoration(labelText: 'Type'),
                ),
                TextField(
                  controller: pricePaidController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(labelText: 'Price Paid'),
                ),
                TextField(
                  controller: conditionController,
                  decoration: const InputDecoration(labelText: 'Condition'),
                ),
                TextField(
                  controller: averagePriceController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
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
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                // ... existing code for saving data ...
                final newChemical = InventoryChemicals(
                  chemical: selectedChemical ?? 'Unknown', // Provide a default value if selectedChemical is null
                  type: typeController.text,
                  pricePaid: double.tryParse(pricePaidController.text),
                  condition: conditionController.text,
                  averagePrice: double.tryParse(averagePriceController.text),
                  comments: commentsController.text,
                );

                await ChemicalsDatabaseHelper.insertChemicals(newChemical);
                _loadChemicals();

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
        title: const Text('Photochemistry Collection'),
      ),
      body: _chemicals.isEmpty
          ? const Center(child: Text("No items found"))
          : ListView.builder(
        itemCount: _chemicals.length,
        itemBuilder: (context, index) {
          var chemical = _chemicals[index];
          return ListTile(
            title: Text('${chemical.chemical}'),
            subtitle: Text('Type: ${chemical.type}'),
            onTap: () {
              // Implement tap functionality, e.g., navigate to a detail/edit page
            },
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 16.0, bottom: 16.0),
        child: FloatingActionButton(
          onPressed: () => _showAddChemicalsDialog(context),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
