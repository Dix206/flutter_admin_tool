import 'package:flutter/material.dart';
import 'package:flutter_cms/data_types/navigation_infos.dart';

/// T is the type of the logged in user
class AuthStateService<T extends Object> with ChangeNotifier {
  final CmsAuthInfos<T> _cmsAuthInfos;

  T? _loggedInUser;
  bool _isInitialized = false;

  AuthStateService(
    this._cmsAuthInfos,
  ) {
    _init();
  }

  T? get loggedInUser => _loggedInUser;
  bool get isLoggedIn => _loggedInUser != null;
  bool get isInitialized => _isInitialized;

  Future<void> onUserLoggedIn() async {
    _loggedInUser = await _cmsAuthInfos.getLoggedInUser();
    notifyListeners();
  }

  Future<void> onUserLoggedOut() async {
    await _cmsAuthInfos.onLogout();
    _loggedInUser = null;
    notifyListeners();
  }

  Future<void> _init() async {
    _loggedInUser = await _cmsAuthInfos.getLoggedInUser();
    _isInitialized = true;
    notifyListeners();
  }
}
