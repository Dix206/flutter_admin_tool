import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_example/auth_service.dart';
import 'package:firebase_example/article/article_flat_object.dart';
import 'package:firebase_example/blog/blog_flat_object.dart';
import 'package:firebase_example/event/event_flat_object.dart';
import 'package:firebase_example/firebase_options.dart';
import 'package:firebase_example/login.dart';
import 'package:firebase_example/register.dart';
import 'package:flat/flat.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    FlatApp(
      getFlatObjectStructures: (account) => [
        getBlogFlatObject(account),
        articleFlatObject,
        eventFlatObject,
      ],
      getFlatUserInfos: (account) => FlatUserInfos(
        name: account.displayName,
        email: account.email,
        role: account.email == "admin@admin.de" ? "Admin" : "User",
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
