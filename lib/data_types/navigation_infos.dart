import 'package:flutter/widgets.dart';

/// T is the type of the logged in user
class CmsAuthInfos<T extends Object> {
  /// This method returns the logged in user which is of type T or null if no user is logged in
  final Future<T?> Function() getLoggedInUser;
  final Widget Function(Function() onLoginSuccess) loginScreenBuilder;
  final Future<void> Function() onLogout;

  CmsAuthInfos({
    required this.getLoggedInUser,
    required this.loginScreenBuilder,
    required this.onLogout,
  });
}
