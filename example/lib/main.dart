import 'package:example/appwrite/auth_service.dart';
import 'package:example/article/article_cms_object.dart';
import 'package:example/blog/blog_cms_object.dart';
import 'package:example/event/event_cms_object.dart';
import 'package:example/login.dart';
import 'package:example/register.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cms/data_types/cms_custom_menu_entry.dart';
import 'package:flutter_cms/data_types/cms_unauthorized_route.dart';
import 'package:flutter_cms/data_types/navigation_infos.dart';
import 'package:flutter_cms/flutter_cms.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    FlutterCms(
      getCmsObjectStructures: (account) => [
        getBlogCmsObject(account),
        articleCmsObject,
        eventCmsObject,
      ],
      cmsAuthInfos: CmsAuthInfos(
        getLoggedInUser: authAppwriteService.getLoggedInUser,
        onLogout: authAppwriteService.logout,
        loginScreenBuilder: (onLoginSuccess) => LoginScreen(onLoginSuccess: onLoginSuccess),
      ),
      customMenuEntries: [
        CmsCustomMenuEntry(
          id: "text",
          displayName: "Test",
          contentBuilder: (context) => const Center(
            child: Text("Hello, I am custom content!"),
          ),
        ),
      ],
      cmsUnauthorizedRoutes: [
        CmsUnauthorizedRoute(
          path: "/register/:parameter",
          childBuilder: (context, state) {
            final parameter = state.params["parameter"] ?? "";
            return RegisterScreen(parameter: parameter);
          },
        ),
      ],
      supportedLocales: const [
        Locale('de'),
        Locale('en'),
      ],
    ),
  );
}
