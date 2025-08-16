import 'package:equatable/equatable.dart';

class Restaurant extends Equatable {
  final String id, name, address, ownerUid;
  final String? phone;
  final bool isOpen;
  const Restaurant({
    required this.id,
    required this.name,
    required this.address,
    required this.ownerUid,
    required this.isOpen,
    this.phone,
  });
  factory Restaurant.fromMap(String id, Map<String, dynamic> m) => Restaurant(
    id: id ?? "",
    name: m['name'] ?? "",
    address: m['address'] ?? "address",
    ownerUid: m['ownerUid'] ?? "",
    isOpen: m['isOpen'] ?? true,
    phone: m['phone'] ?? "XXXXXXXXXX",
  );
  Map<String, dynamic> toMap() => {
    'name': name,
    'address': address,
    'ownerUid': ownerUid,
    'isOpen': isOpen,
    'phone': phone ?? "XXXXXXXXXX",
  };
  @override
  List<Object?> get props => [id, name, address, ownerUid, isOpen, phone];
}
