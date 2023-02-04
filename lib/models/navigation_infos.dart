import 'package:flutter/widgets.dart';

class CmsAuthInfos {
  final Future<bool> Function() isUserLoggedIn;
  final Widget Function(Function() onLoginSuccess) loginScreenBuilder;
  final Future<void> Function() onLogout;

  CmsAuthInfos({
    required this.isUserLoggedIn,
    required this.loginScreenBuilder,
    required this.onLogout,
  });
}
