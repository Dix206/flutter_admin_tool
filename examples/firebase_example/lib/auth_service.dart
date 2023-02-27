import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flat/flat.dart';

final authAppwriteService = AuthFirebaseService();

class AuthFirebaseService {
  AuthFirebaseService();

  Future<FlatResult<Unit>> login({
    required String email,
    required String password,
  }) async {
    try {
      final credentials = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return credentials.user != null ? FlatResult.success(const Unit()) : FlatResult.error("Login failed");
    } catch (e) {
      return FlatResult.error("Login failed");
    }
  }

  Future<void> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      // ignore
    }
  }

  Future<User?> getLoggedInUser() async {
    try {
      return FirebaseAuth.instance.currentUser;
    } catch (_) {
      return null;
    }
  }
}
