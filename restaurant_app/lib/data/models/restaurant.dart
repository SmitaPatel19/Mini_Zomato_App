import 'package:equatable/equatable.dart';

class Restaurant extends Equatable {
  final String id, name, address, ownerUid;
  final bool isOpen;
  const Restaurant({
    required this.id,
    required this.name,
    required this.address,
    required this.ownerUid,
    required this.isOpen,
  });
  factory Restaurant.fromMap(String id, Map<String, dynamic> m) => Restaurant(
    id: id,
    name: m['name'],
    address: m['address'],
    ownerUid: m['ownerUid'],
    isOpen: m['isOpen'] ?? true,
  );
  Map<String, dynamic> toMap() => {
    'name': name,
    'address': address,
    'ownerUid': ownerUid,
    'isOpen': isOpen,
  };
  @override
  List<Object?> get props => [id, name, address, ownerUid, isOpen];
}
