import 'package:equatable/equatable.dart';

class UserProfile extends Equatable {
  final String uid;
  final String name;
  final String role; // 'user' | 'restaurant' | 'delivery'
  final String? phone;
  const UserProfile({required this.uid, required this.name, required this.role, this.phone});

  factory UserProfile.fromMap(String id, Map<String, dynamic> m) =>
      UserProfile(uid: id, name: m['name'] ?? '', role: m['role'] ?? 'user', phone: m['phone']);

  Map<String, dynamic> toMap() => {'name': name, 'role': role, 'phone': phone};
  @override List<Object?> get props => [uid, name, role, phone];
}