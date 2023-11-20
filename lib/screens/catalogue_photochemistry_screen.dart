import 'package:flutter/material.dart';
import 'package:analog_photography_db/database_helpers/chemicals_catalogue_database_helper.dart';

class CataloguePhotochemistryScreen extends StatefulWidget {
  const CataloguePhotochemistryScreen({Key? key}) : super(key: key);

  @override
  _CataloguePhotochemistryScreenState createState() => _CataloguePhotochemistryScreenState();
}

class _CataloguePhotochemistryScreenState extends State<CataloguePhotochemistryScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  Future<List<String>> _fetchChemicals(String table, String columnName) async {
    var data = await ChemicalsDatabaseHelper().getChemicals(table, columnName);
    return data.map((e) => e[columnName].toString()).toList();
  }

  Widget _buildChemicalList(String table, String columnName) {
    return FutureBuilder<List<String>>(
      future: _fetchChemicals(table, columnName),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(snapshot.data![index]),
                // onTap logic here if needed
              );
            },
          );
        } else {
          return const Text('No data available');
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Photochemistry Catalogue'),
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
          _buildChemicalList('developers', 'developer'), // Fetch 'developer' column from 'developers' table
          _buildChemicalList('fixers', 'fixer'),        // Fetch 'fixer' column from 'fixers' table
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}


