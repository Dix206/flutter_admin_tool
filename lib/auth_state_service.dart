import 'package:flutter/material.dart';
import 'package:flutter_cms/models/navigation_infos.dart';

class AuthStateService with ChangeNotifier {
  final CmsAuthInfos _cmsAuthInfos;

  bool _isLoggedIn = false;
  bool _isInitialized = false;

  AuthStateService(
    this._cmsAuthInfos,
  ) {
    _init();
  }

  bool get isLoggedIn => _isLoggedIn;
  bool get isInitialized => _isInitialized;

  void onUserLoggedIn() {
    _isLoggedIn = true;
    notifyListeners();
  }

  void onUserLoggedOut() {
    _isLoggedIn = false;
    notifyListeners();
  }

  Future<void> _init() async {
    _isLoggedIn = await _cmsAuthInfos.isUserLoggedIn();
    _isInitialized = true;
    notifyListeners();
  }
}