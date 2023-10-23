import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:analog_photography_db/models/inventory_films.dart';
import 'package:analog_photography_db/database_helpers/inventory_collection/films_database_helper.dart';

class FilmsListItem extends StatelessWidget {
  final InventoryFilms films;
  final Function onDelete;

  const FilmsListItem({Key? key, required this.films, required this.onDelete}) : super(key: key);


  void _showFilmsDetails(BuildContext context, InventoryFilms films) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("${films.brand} ${films.name}"),
        content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8, // 80% of screen width
          height: MediaQuery.of(context).size.height * 0.5, // 50% of screen height
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                if (films.type != null)
                  Text('Film type: ${films.type}',
                      style: const TextStyle(fontSize: 20)),

                const SizedBox(height: 10),
                if (films.sizeType != null)
                  Text('Size type: ${films.sizeType}',
                      style: const TextStyle(fontSize: 20)),

                const SizedBox(height: 10),
                if (films.iso != null)
                  Text('ISO: ${films.iso}',
                      style: const TextStyle(fontSize: 20)),

                const SizedBox(height: 10),
                if (films.expirationDate != null)
                  Text('Expiration date: ${DateFormat('yyyy-MM-dd').format(films.expirationDate!)}',
                      style: const TextStyle(fontSize: 20)),

                const SizedBox(height: 10),
                if (films.isExpired != null)
                  Text('Is film expired?: ${films.isExpired}',
                      style: const TextStyle(fontSize: 20)),

                const SizedBox(height: 10),
                if (films.quantity != null)
                  Text('Quantity: ${films.quantity}',
                      style: const TextStyle(fontSize: 20)),

                const SizedBox(height: 10),
                if (films.averagePrice != null)
                  Text('Average Price: \$${films.averagePrice}',
                      style: const TextStyle(fontSize: 20)),

                const SizedBox(height: 10),
                if (films.comments != null)
                  Text('Comments: ${films.comments}',
                      style: const TextStyle(fontSize: 20)),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            child: const Text("Close"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text("${films.brand} ${films.name}"),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Align the text to the left
        children: [
          Text('Expiration Date: ${films.expirationDate != null ? DateFormat('yyyy-MM').format(films.expirationDate!) : 'Not set'}'),
          Text('Quantity: ${films.quantity}'),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // Implement edit functionality later
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              final bool confirmed = await _showDeleteConfirmation(context);
              if (confirmed && films.id != null) {  // Check if films.id is non-nullable
                // Delete the film from the database
                await FilmsDatabaseHelper.deleteFilms(films.id!);
                onDelete();
                // Optionally: Refresh the list or remove the film from the in-memory list
                // This can be done using a callback or a state management solution
              }
            },
          ),
        ],
      ),
      onTap: () {
        _showFilmsDetails(context, films);
      },
    );
  }

  Future<bool> _showDeleteConfirmation(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Film'),
        content: const Text('Are you sure you want to delete this film?'),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
          TextButton(
            child: const Text('Delete'),
            onPressed: () {
              Navigator.of(context).pop(true);
            },
          ),
        ],
      ),
    ) ?? false;  // Return false if user taps outside the dialog
  }
}

