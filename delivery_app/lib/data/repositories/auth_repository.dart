import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_profile.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // SIGN UP for restaurant
  Future<User> signUp(String email, String pass, {required String name, required String role}) async {
    final cred = await _auth.createUserWithEmailAndPassword(
        email: email, password: pass);

    await _db.collection('users').doc(cred.user!.uid).set({'name': name, 'role': role, 'phone': '1234567890'});
    await _db.collection('delivery_partners').doc(cred.user!.uid).set({
      'name': name,
      'phone': '1234567890',
      'createdAt': FieldValue.serverTimestamp(),
      'location': GeoPoint(0, 0),
      'active': true
    });

    return cred.user!;
  }

  String? get currentDeliveryId {
    final user = _auth.currentUser;
    return user?.uid; // Using Firebase UID as restaurant ID
  }

  Future<User> signIn(String email, String password) async {
    final cred =
    await _auth.signInWithEmailAndPassword(email: email, password: password);
    final doc = await _db.collection('users').doc(cred.user!.uid).get();
    if (!doc.exists) throw Exception('User not found');
    final profile = UserProfile.fromMap(doc.id, doc.data()!);
    if (profile.role != 'restaurant') throw Exception('Not a restaurant account');
    return cred.user!;
  }

  // SIGN OUT
  Future<void> signOut() => _auth.signOut();

  // AUTH STATE STREAM
  Stream<User?> authState() => _auth.authStateChanges();

  Future<UserProfile?> currentProfile() async {
    final u = _auth.currentUser;
    if (u == null) return null;
    final doc = await _db.collection('users').doc(u.uid).get();
    return doc.exists ? UserProfile.fromMap(doc.id, doc.data()!) : null;
  }
}
