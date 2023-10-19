import 'package:intl/intl.dart';

class InventoryFilms {
  int? id;
  String brand;
  String name;
  String type;
  String sizeType;
  String? iso;
  DateTime? expirationDate;
  String? isExpired;
  int? quantity;
  double? averagePrice;
  String? comments;

  InventoryFilms({
    this.id,
    required this.brand,
    required this.name,
    required this.type,
    required this.sizeType,
    this.iso,
    this.expirationDate,
    this.isExpired,
    this.quantity,
    this.averagePrice,
    this.comments,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'brand': brand,
      'name': name,
      'type': type,
      'size_type': sizeType,
      'ISO': iso,
      'expiration_date': expirationDate != null ? DateFormat('yyyy-MM-dd').format(expirationDate!) : null,
      'is_expired': isExpired,
      'quantity': quantity,
      'average_price': averagePrice,
      'comments': comments,
    };
  }

  static InventoryFilms fromMap(Map<String, dynamic> map) {
    return InventoryFilms(
      id: map['id'],
      brand: map['brand'],
      name: map['name'],
      type: map['type'],
      sizeType: map['size_type'],
      iso: map['ISO'],
      expirationDate: map['expiration_date'] != null ? DateFormat('yyyy-MM-dd').parse(map['expiration_date']) : null,
      isExpired: map['is_expired'],
      quantity: map['quantity'],
      averagePrice: map['average_price'],
      comments: map['comments'],
    );
  }
}
