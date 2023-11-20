import 'package:flutter/material.dart';
import 'package:analog_photography_db/database_helpers/chemicals_catalogue_database_helper.dart';

class CatalogueChemicalsScreen extends StatefulWidget {
  const CatalogueChemicalsScreen({Key? key}) : super(key: key);

  @override
  _CatalogueChemicalsScreenState createState() => _CatalogueChemicalsScreenState();
}

class _CatalogueChemicalsScreenState extends State<CatalogueChemicalsScreen> with SingleTickerProviderStateMixin {
  TabController? _tabController;
  List<Map<String, dynamic>> developers = [];
  List<Map<String, dynamic>> fixers = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadChemicals();
  }

  _loadChemicals() async {
    try {
      developers = await ChemicalsDatabaseHelper().getChemicals('developers', 'developer');
      fixers = await ChemicalsDatabaseHelper().getChemicals('fixers', 'fixer');
      setState(() {});
    } catch (e) {
      print("Error loading chemicals: $e");
    }
  }

  void _showChemicalDetails(BuildContext context, Map<String, dynamic> chemical, String type) {
    String folder = type == 'developer' ? 'developers' : 'fixers';
    String imagePath = 'assets/images/$folder/${chemical['id'].toString()}.jpg'; // Adjust file extension as needed

    print('Image path: $imagePath');

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(imagePath, errorBuilder: (context, error, stackTrace) {
                  return const Text('Image not available');
                }),
                Text(chemical[type]), // Display the chemical name
                // ... Add more details if needed ...
              ],
            ),
          ),
          actions: <Widget>[
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chemicals Catalogue'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Developers'),
            Tab(text: 'Fixers'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildChemicalList(developers, 'developer'),
          _buildChemicalList(fixers, 'fixer'),
        ],
      ),
    );
  }

  Widget _buildChemicalList(List<Map<String, dynamic>> chemicals, String type) {
    return ListView.builder(
      itemCount: chemicals.length,
      itemBuilder: (context, index) {
        var chemical = chemicals[index];
        return ListTile(
          title: Text(chemical[type]),
          onTap: () => _showChemicalDetails(context, chemical, 'developer')
        );
      },
    );
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }
}
