import 'package:flutter/material.dart';
import 'package:flutter_admin_tool/data_types/flat_texts.dart';
import 'package:flutter_admin_tool/data_types/flat_unauthorized_route.dart';
import 'package:flutter_admin_tool/data_types/flat_user_infos.dart';
import 'package:flutter_admin_tool/ui/auth_state_service.dart';
import 'package:flutter_admin_tool/data_types/flat_object_structure.dart';
import 'package:flutter_admin_tool/extensions/iterable_extensions.dart';
import 'package:flutter_admin_tool/data_types/flat_auth_infos.dart';
import 'package:flutter_admin_tool/ui/routes.dart';
import 'package:flutter_admin_tool/ui/theme_mode_handler.dart';
import 'package:flutter_admin_tool/data_types/flat_custom_menu_entry.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

/// This method will return a list of all flat object structures based on the passed user object which is of type T
typedef GetFlatObjectStructures<T extends Object> = List<FlatObjectStructure> Function(T loggedInUser);

/// This method will return the [FlatUserInfos] based on the passed user object which is of type T
typedef GetFlatUserInfos<T extends Object> = FlatUserInfos Function(T loggedInUser);

/// T is the type of the logged in user
class FlatApp<T extends Object> extends StatelessWidget {
  final GetFlatObjectStructures<T> getFlatObjectStructures;

  /// The returned [FlatUserInfos] will be displayed in the menu. If a value is null, no user informations will be displayed.
  final GetFlatUserInfos<T>? getFlatUserInfos;
  final FlatAuthInfos<T> flatAuthInfos;
  final List<Locale> supportedLocales;
  final List<FlatUnauthorizedRoute> flatUnauthorizedRoutes;
  final List<FlatCustomMenuEntry> flatCustomMenuEntries;
  final FlatTexts flatTexts;
  final ThemeData? lightTheme;
  final ThemeData? darkTheme;

  const FlatApp({
    super.key,
    required this.getFlatObjectStructures,
    required this.flatAuthInfos,
    required this.supportedLocales,
    this.getFlatUserInfos,
    this.flatTexts = const FlatTexts(),
    this.flatCustomMenuEntries = const [],
    this.flatUnauthorizedRoutes = const [],
    this.lightTheme,
    this.darkTheme,
  });

  @override
  Widget build(BuildContext context) {
    final authStateService = AuthStateService(flatAuthInfos);

    final router = getGoRouter(
      flatAuthInfos: flatAuthInfos,
      getFlatObjectStructures: getFlatObjectStructures,
      authStateService: authStateService,
      flatCustomMenuEntries: flatCustomMenuEntries,
      flatUnauthorizedRoutes: flatUnauthorizedRoutes,
      flatTexts: flatTexts,
    );

    return ThemeModeHandler(
      childBuilder: (themeMode) => MaterialApp.router(
        routeInformationProvider: router.routeInformationProvider,
        routerDelegate: router.routerDelegate,
        routeInformationParser: router.routeInformationParser,
        theme: lightTheme ??
            ThemeData.from(
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color(0xFF5C5D8D),
                background: const Color.fromARGB(255, 243, 242, 252),
                surface: const Color.fromARGB(255, 228, 227, 235),
              ),
            ),
        darkTheme: darkTheme ??
            ThemeData.from(
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color.fromARGB(255, 160, 161, 206),
                background: const Color.fromARGB(255, 50, 50, 52),
                surface: const Color.fromARGB(255, 82, 81, 87),
                brightness: Brightness.dark,
              ),
            ),
        themeMode: themeMode,
        title: flatTexts.appTitle,
        builder: (context, child1) => AnimatedBuilder(
          animation: authStateService,
          child: child1,
          builder: (context, child) {
            if (!authStateService.isInitialized) {
              return const SizedBox();
            } else {
              return authStateService.isLoggedIn
                  ? _FlatObjectsInherited(
                      flatObjectStructures: getFlatObjectStructures(authStateService.loggedInUser!),
                      flatAuthInfos: flatAuthInfos,
                      authStateService: authStateService,
                      flatCustomMenuEntries: flatCustomMenuEntries,
                      flatUserInfos: getFlatUserInfos?.call(authStateService.loggedInUser!),
                      flatTexts: flatTexts,
                      child: child!,
                    )
                  : child!;
            }
          },
        ),
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: supportedLocales,
      ),
    );
  }

  static FlatUserInfos? getUserInfos(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_FlatObjectsInherited>()!.flatUserInfos;
  }

  static AuthStateService getAuthStateService(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_FlatObjectsInherited>()!.authStateService;
  }

  static FlatAuthInfos getFlatAuthInfos(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_FlatObjectsInherited>()!.flatAuthInfos;
  }

  static List<FlatObjectStructure> getAllFlatObjectStructures(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_FlatObjectsInherited>()!.flatObjectStructures;
  }

  static List<FlatCustomMenuEntry> getFlatCustomMenuEntries(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_FlatObjectsInherited>()!.flatCustomMenuEntries;
  }

  static FlatTexts getFlatTexts(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_FlatObjectsInherited>()!.flatTexts;
  }

  static FlatObjectStructure? getFlatObjectStructureById({
    required BuildContext context,
    required String flatObjectId,
  }) {
    final allFlatObjectStructures = getAllFlatObjectStructures(context);
    return allFlatObjectStructures.firstWhereOrNull((object) => object.id.toLowerCase() == flatObjectId.toLowerCase());
  }
}

class _FlatObjectsInherited extends InheritedWidget {
  final List<FlatObjectStructure> flatObjectStructures;
  final List<FlatCustomMenuEntry> flatCustomMenuEntries;
  final FlatAuthInfos flatAuthInfos;
  final AuthStateService authStateService;
  final FlatUserInfos? flatUserInfos;
  final FlatTexts flatTexts;

  _FlatObjectsInherited({
    required this.flatObjectStructures,
    required this.flatCustomMenuEntries,
    required this.flatAuthInfos,
    required this.authStateService,
    required this.flatUserInfos,
    required this.flatTexts,
    required super.child,
  }) : assert(
          flatObjectStructures.every(
            (object) => flatObjectStructures.every(
              (otherObject) => object.id != otherObject.id || object == otherObject,
            ),
          ),
          'There are two objects with the same id',
        );

  @override
  bool updateShouldNotify(_FlatObjectsInherited oldWidget) {
    return flatObjectStructures != oldWidget.flatObjectStructures ||
        flatAuthInfos != oldWidget.flatAuthInfos ||
        flatCustomMenuEntries != oldWidget.flatCustomMenuEntries ||
        flatUserInfos != oldWidget.flatUserInfos ||
        flatTexts != oldWidget.flatTexts ||
        authStateService != oldWidget.authStateService;
  }
}
