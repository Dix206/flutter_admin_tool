import 'dart:async';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:example/appwrite/client.dart';
import 'package:flat/flat.dart';

final authAppwriteService = AuthAppwriteService(account);

class AuthAppwriteService {
  final Account _account;

  AuthAppwriteService(this._account);

  Future<FlatResult<Unit>> login({
    required String email,
    required String password,
  }) async {
    try {
      await _account.createEmailSession(
        email: email,
        password: password,
      );

      return FlatResult.success(const Unit());
    } catch (e) {
      return FlatResult.error("Login failed");
    }
  }

  Future<void> logout() async {
    try {
      await _account.deleteSessions();
    } catch (e) {
      // ignore
    }
  }

  Future<User?> getLoggedInUser() async {
    try {
      final account = await _account.get();
      return account;
    } catch (_) {
      return null;
    }
  }
}
