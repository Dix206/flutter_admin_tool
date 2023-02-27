import 'package:flutter/material.dart';
import 'package:flat/data/app_shared_preferences.dart';

class ThemeModeHandler extends StatefulWidget {
  final Widget Function(ThemeMode themeMode) childBuilder;

  const ThemeModeHandler({
    Key? key,
    required this.childBuilder,
  }) : super(key: key);

  @override
  State createState() => _ThemeModeHandlerState();

  static Future<void> setThemeMode({
    required BuildContext context,
    required ThemeMode themeMode,
  }) async {
    await context.findAncestorStateOfType<_ThemeModeHandlerState>()!.setThemeMode(themeMode);
  }

  static ThemeMode getThemeMode(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_ThemeModeHandlerInherited>()!.themeMode;
}

class _ThemeModeHandlerState extends State<ThemeModeHandler> {
  ThemeMode? _themeMode;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> setThemeMode(ThemeMode value) async {
    setState(() => _themeMode = value);
    await appSharedPreferences.setIsDarkModeActive(value == ThemeMode.dark);
  }

  Future<void> _init() async {
    final isDarkModeActive = await appSharedPreferences.isDarkModeActive();
    final theme = isDarkModeActive == null
        ? ThemeMode.system
        : isDarkModeActive
            ? ThemeMode.dark
            : ThemeMode.light;

    setState(() => _themeMode = theme);
  }

  @override
  Widget build(BuildContext context) {
    return _themeMode == null
        ? const SizedBox()
        : _ThemeModeHandlerInherited(
            themeMode: _themeMode!,
            child: widget.childBuilder(_themeMode!),
          );
  }
}

class _ThemeModeHandlerInherited extends InheritedWidget {
  final ThemeMode themeMode;

  const _ThemeModeHandlerInherited({
    required this.themeMode,
    required super.child,
  });

  @override
  bool updateShouldNotify(_ThemeModeHandlerInherited oldWidget) {
    return themeMode != oldWidget.themeMode;
  }
}
