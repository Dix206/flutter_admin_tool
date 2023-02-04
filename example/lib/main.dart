import 'package:example/author_object.dart';
import 'package:example/book_object.dart';
import 'package:example/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cms/models/navigation_infos.dart';
import 'package:flutter_cms/ui/flutter_cms_widget.dart';

void main() {
  runApp(
    FlutterCms(
      cmsObjects: [
        authorCmsObject,
        booksCmsObject,
      ],
      cmsAuthInfos: CmsAuthInfos(
        isUserLoggedIn: () async => false,
        onLogout: () async {},
        loginScreenBuilder: (onLoginSuccess) =>
            LoginScreen(onLoginSuccess: onLoginSuccess),
      ),
    ),
  );
}
