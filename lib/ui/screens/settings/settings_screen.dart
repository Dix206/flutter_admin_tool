import 'package:flutter/material.dart';
import 'package:flutter_admin_tool/flat_app.dart';
import 'package:flutter_admin_tool/ui/theme_mode_handler.dart';
import 'package:flutter_admin_tool/ui/widgets/flat_top_bar.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authStateService = FlatApp.getAuthStateService(context);
    final themeMode = ThemeModeHandler.getThemeMode(context);

    return Column(
      children: [
        FlatTopBar(
          title: FlatApp.getFlatTexts(context).settings,
        ),
        Expanded(
          child: ListView(
            children: [
              const SizedBox(height: 16),
              SwitchListTile(
                value:
                    (themeMode == ThemeMode.system && MediaQuery.of(context).platformBrightness == Brightness.dark) ||
                        themeMode == ThemeMode.dark,
                onChanged: (value) => ThemeModeHandler.setThemeMode(
                  context: context,
                  themeMode: value ? ThemeMode.dark : ThemeMode.light,
                ),
                title: Text(FlatApp.getFlatTexts(context).darkMode),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    onPressed: authStateService.onUserLoggedOut,
                    child: Text(FlatApp.getFlatTexts(context).logout),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ],
    );
  }
}
