import 'package:flutter/material.dart';
import 'package:flutter_cms/flutter_cms.dart';
import 'package:flutter_cms/ui/theme_mode_handler.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authStateService = FlutterCms.getAuthStateService(context);
    final themeMode = ThemeModeHandler.getThemeMode(context);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        SwitchListTile(
          value: (themeMode == ThemeMode.system && MediaQuery.of(context).platformBrightness == Brightness.dark) ||
              themeMode == ThemeMode.dark,
          onChanged: (value) => ThemeModeHandler.setThemeMode(
            context: context,
            themeMode: value ? ThemeMode.dark : ThemeMode.light,
          ),
          title: const Text("Dark Mode"),
        ),
        const SizedBox(height: 24),
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton(
            onPressed: authStateService.onUserLoggedOut,
            child: const Text("Logout"),
          ),
        ),
      ],
    );
  }
}
