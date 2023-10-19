import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:analog_photography_db/models/inventory_films.dart';

class FilmsListItem extends StatelessWidget {
  final InventoryFilms films;

  const FilmsListItem({super.key, required this.films});

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
                  Text('Serial Number: ${films.type}',
                      style: const TextStyle(fontSize: 20)),

                const SizedBox(height: 10),
                if (films.sizeType != null)
                  Text('Serial Number: ${films.sizeType}',
                      style: const TextStyle(fontSize: 20)),

                const SizedBox(height: 10),
                if (films.iso != null)
                  Text('Serial Number: ${films.iso}',
                      style: const TextStyle(fontSize: 20)),

                const SizedBox(height: 10),
                if (films.expirationDate != null)
                  Text('Purchase Date: ${DateFormat('yyyy-MM-dd').format(films.expirationDate!)}',
                      style: const TextStyle(fontSize: 20)),

                const SizedBox(height: 10),
                if (films.isExpired != null)
                  Text('Price Paid: ${films.isExpired}',
                      style: const TextStyle(fontSize: 20)),

                const SizedBox(height: 10),
                if (films.quantity != null)
                  Text('Condition: ${films.quantity}',
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
      subtitle: Text('expiration date: ${films.expirationDate}'),
      onTap: () {
        _showFilmsDetails(context, films);
      },
    );
  }
}
