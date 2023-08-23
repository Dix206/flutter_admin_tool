import 'package:example/appwrite/auth_service.dart';
import 'package:example/article/article_flat_object.dart';
import 'package:example/blog/blog_flat_object.dart';
import 'package:example/event/event_flat_object.dart';
import 'package:example/login.dart';
import 'package:example/register.dart';
import 'package:flutter_admin_tool/flat.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    FlatApp(
      getFlatObjectStructures: (account) => [
        getBlogFlatObject(account),
        articleFlatObject,
        eventFlatObject,
      ],
      getFlatUserInfos: (account) => FlatUserInfos(
        name: account.name,
        email: account.email,
        role: account.prefs.data["role"] == "admin" ? "Admin" : "User",
      ),
      flatAuthInfos: FlatAuthInfos(
        getLoggedInUser: authAppwriteService.getLoggedInUser,
        onLogout: authAppwriteService.logout,
        loginScreenBuilder: (onLoginSuccess) => LoginScreen(onLoginSuccess: onLoginSuccess),
      ),
      flatCustomMenuEntries: [
        FlatCustomMenuEntry(
          id: "test",
          displayName: "Test",
          contentBuilder: (context) => const Column(
            children: [
              FlatTopBar(
                title: "Custom Content Title",
              ),
              Expanded(
                child: Center(
                  child: Text("Hello, I am custom content!"),
                ),
              ),
            ],
          ),
        ),
      ],
      flatUnauthorizedRoutes: [
        FlatUnauthorizedRoute(
          path: "/register/:parameter",
          pageBuilder: (context, state) {
            final parameter = state.pathParameters["parameter"] ?? "";
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
