// lib/models/menu_item.dart
import 'package:equatable/equatable.dart';

class MenuItem extends Equatable {
  final String id;
  final String restaurantId;
  final String name;
  final double price;
  final String imageUrl;
  final bool isAvailable;

  const MenuItem({
    required this.id,
    required this.restaurantId,
    required this.name,
    required this.price,
    this.imageUrl = '',
    this.isAvailable = true,
  });

  MenuItem copyWith({
    String? id,
    String? restaurantId,
    String? name,
    double? price,
    String? imageUrl,
    bool? isAvailable,
  }) {
    return MenuItem(
      id: id ?? this.id,
      restaurantId: restaurantId ?? this.restaurantId,
      name: name ?? this.name,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      isAvailable: isAvailable ?? this.isAvailable,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'restaurantId': restaurantId,
      'name': name,
      'price': price,
      'imageUrl': imageUrl,
      'isAvailable': isAvailable,
    };
  }

  factory MenuItem.fromMap(String id, Map<String, dynamic> map) {
    final priceVal = map['price'];
    double priceDouble;
    if (priceVal is int) priceDouble = priceVal.toDouble();
    else if (priceVal is double) priceDouble = priceVal;
    else if (priceVal is String) priceDouble = double.tryParse(priceVal) ?? 0.0;
    else priceDouble = 0.0;

    return MenuItem(
      id: id,
      restaurantId: map['restaurantId'] ?? '',
      name: map['name'] ?? '',
      price: priceDouble,
      imageUrl: map['imageUrl'] ?? '',
      isAvailable: map['isAvailable'] ?? true,
    );
  }

  @override
  List<Object?> get props => [id, restaurantId, name, price, imageUrl, isAvailable];
}
