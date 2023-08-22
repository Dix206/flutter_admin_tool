import 'package:flat/flat.dart';
import 'package:flutter/material.dart';
import 'package:frontend/login.dart';
import 'package:frontend/register.dart';

import 'event/event_flat_object.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    FlatApp(
      getFlatObjectStructures: (account) => [
        // getBlogFlatObject(account),
        // articleFlatObject,
        eventFlatObject,
      ],
      getFlatUserInfos: (role) => FlatUserInfos(
        name: role,
        role: role,
      ),
      flatAuthInfos: FlatAuthInfos(
        getLoggedInUser: () async => "admin",
        onLogout: () async {},
        loginScreenBuilder: (onLoginSuccess) => LoginScreen(onLoginSuccess: onLoginSuccess),
      ),
      flatCustomMenuEntries: [
        FlatCustomMenuEntry(
          id: "test",
          displayName: "Test",
          contentBuilder: (context) => Column(
            children: const [
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
