import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/user_profile.dart';

class AuthRepository {
  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;

  Future<User> signUp(
    String email,
    String pass, {
    required String name,
    required String role,
  }) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: pass,
    );
    await _db.collection('users').doc(cred.user!.uid).set({
      'name': name,
      'role': role,
      'phone': '',
    });
    return cred.user!;
  }

  Future<User> signIn(String email, String pass) async =>
      (await _auth.signInWithEmailAndPassword(
        email: email,
        password: pass,
      )).user!;

  Stream<User?> authState() => _auth.authStateChanges();

  Future<UserProfile?> currentProfile() async {
    final u = _auth.currentUser;
    if (u == null) return null;
    final doc = await _db.collection('users').doc(u.uid).get();
    return doc.exists ? UserProfile.fromMap(doc.id, doc.data()!) : null;
  }
}
