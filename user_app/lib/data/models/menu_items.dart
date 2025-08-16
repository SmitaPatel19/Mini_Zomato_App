import 'package:equatable/equatable.dart';

class MenuItem extends Equatable {
  final String id, restaurantId, name, imageUrl;
  final num price;
  final bool isAvailable;
  const MenuItem({
    required this.id,
    required this.restaurantId,
    required this.name,
    required this.price,
    this.imageUrl = '',
    this.isAvailable = true,
  });
  factory MenuItem.fromMap(String id, Map<String, dynamic> m) => MenuItem(
    id: id,
    restaurantId: m['restaurantId'],
    name: m['name'],
    price: m['price'],
    imageUrl: m['imageUrl'] ?? '',
    isAvailable: m['isAvailable'] ?? true,
  );
  Map<String, dynamic> toMap() => {
    'restaurantId': restaurantId,
    'name': name,
    'price': price,
    'imageUrl': imageUrl,
    'isAvailable': isAvailable,
  };
  @override
  List<Object?> get props => [
    id,
    restaurantId,
    name,
    price,
    imageUrl,
    isAvailable,
  ];
}
