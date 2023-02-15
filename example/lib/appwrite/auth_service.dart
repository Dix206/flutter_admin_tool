import 'dart:async';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;
import 'package:example/appwrite/client.dart';
import 'package:flutter_cms/data_types/cms_result.dart';

final authAppwriteService = AuthAppwriteService(account);

class AuthAppwriteService {
  final Account _account;

  AuthAppwriteService(this._account);

  Future<CmsResult<Unit>> login({
    required String email,
    required String password,
  }) async {
    try {
      await _account.createEmailSession(
        email: email,
        password: password,
      );

      return CmsResult.success(const Unit());
    } catch (e) {
      return CmsResult.error("Login failed");
    }
  }

  Future<void> logout() async {
    try {
      await _account.deleteSessions();
    } catch (e) {
      // ignore
    }
  }

  Future<models.Account?> getLoggedInUser() async {
    try {
      final account = await _account.get();
      return account;
    } catch (_) {
      return null;
    }
  }
}
