import 'package:flutter/material.dart';
import 'package:flutter_admin_tool/data_types/flat_auth_infos.dart';

/// T is the type of the logged in user
class AuthStateService<T extends Object> with ChangeNotifier {
  final FlatAuthInfos<T> _flatAuthInfos;

  T? _loggedInUser;
  bool _isInitialized = false;

  AuthStateService(
    this._flatAuthInfos,
  ) {
    _init();
  }

  T? get loggedInUser => _loggedInUser;
  bool get isLoggedIn => _loggedInUser != null;
  bool get isInitialized => _isInitialized;

  Future<void> onUserLoggedIn() async {
    _loggedInUser = await _flatAuthInfos.getLoggedInUser();
    notifyListeners();
  }

  Future<void> onUserLoggedOut() async {
    await _flatAuthInfos.onLogout();
    _loggedInUser = null;
    notifyListeners();
  }

  Future<void> _init() async {
    _loggedInUser = await _flatAuthInfos.getLoggedInUser();
    _isInitialized = true;
    notifyListeners();
  }
}
