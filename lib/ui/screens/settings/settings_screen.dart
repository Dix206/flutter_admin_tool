import 'package:flutter/material.dart';
import 'package:flutter_cms/flutter_cms.dart';
import 'package:flutter_cms/ui/theme_mode_handler.dart';
import 'package:flutter_cms/ui/widgets/cms_top_bar.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authStateService = FlutterCms.getAuthStateService(context);
    final themeMode = ThemeModeHandler.getThemeMode(context);

    return SafeArea(
      child: Column(
        children: [
          CmsTopBar(
            title: FlutterCms.getCmsTexts(context).settings,
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                SwitchListTile(
                  value:
                      (themeMode == ThemeMode.system && MediaQuery.of(context).platformBrightness == Brightness.dark) ||
                          themeMode == ThemeMode.dark,
                  onChanged: (value) => ThemeModeHandler.setThemeMode(
                    context: context,
                    themeMode: value ? ThemeMode.dark : ThemeMode.light,
                  ),
                  title: Text(FlutterCms.getCmsTexts(context).darkMode),
                ),
                const SizedBox(height: 24),
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    onPressed: authStateService.onUserLoggedOut,
                    child: Text(FlutterCms.getCmsTexts(context).logout),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
