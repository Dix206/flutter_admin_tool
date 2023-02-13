import 'package:example/appwrite/auth_service.dart';
import 'package:example/article/article_cms_object.dart';
import 'package:example/blog/blog_cms_object.dart';
import 'package:example/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cms/models/navigation_infos.dart';
import 'package:flutter_cms/ui/flutter_cms_widget.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    FlutterCms(
        cmsObjects: [
          blogCmsObject,
          articleCmsObject,
        ],
        cmsAuthInfos: CmsAuthInfos(
          isUserLoggedIn: authAppwriteService.isUserLoggedIn,
          onLogout: authAppwriteService.logout,
          loginScreenBuilder: (onLoginSuccess) => LoginScreen(onLoginSuccess: onLoginSuccess),
        ),
        supportedLocales: const [
          Locale('de'),
          Locale('en'),
        ]),
  );
}
