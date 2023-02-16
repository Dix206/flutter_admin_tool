import 'package:flutter/material.dart';
import 'package:flutter_cms/data_types/cms_texts.dart';
import 'package:flutter_cms/data_types/cms_unauthorized_route.dart';
import 'package:flutter_cms/data_types/cms_user_infos.dart';
import 'package:flutter_cms/ui/auth_state_service.dart';
import 'package:flutter_cms/data_types/cms_object_structure.dart';
import 'package:flutter_cms/extensions/iterable_extensions.dart';
import 'package:flutter_cms/data_types/navigation_infos.dart';
import 'package:flutter_cms/ui/routes.dart';
import 'package:flutter_cms/ui/theme_mode_handler.dart';
import 'package:flutter_cms/data_types/cms_custom_menu_entry.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

/// This method will return a list of all cms object structures based on the passed user object which is of type T
typedef GetCmsObjectStructures<T extends Object> = List<CmsObjectStructure> Function(T loggedInUser);

/// This method will return the [CmsUserInfos] based on the passed user object which is of type T
typedef GetCmsUserInfos<T extends Object> = CmsUserInfos Function(T loggedInUser);

/// T is the type of the logged in user
class FlutterCms<T extends Object> extends StatelessWidget {
  final GetCmsObjectStructures<T> getCmsObjectStructures;

  /// The returned [CmsUserInfos] will be displayed in the menu. If a value is null, no user informations will be displayed.
  final GetCmsUserInfos<T>? getCmsUserInfos;
  final CmsAuthInfos<T> cmsAuthInfos;
  final List<Locale> supportedLocales;
  final List<CmsUnauthorizedRoute> cmsUnauthorizedRoutes;
  final List<CmsCustomMenuEntry> cmsCustomMenuEntries;
  final CmsTexts cmsTexts;
  final ThemeData? lightTheme;
  final ThemeData? darkTheme;

  const FlutterCms({
    super.key,
    required this.getCmsObjectStructures,
    required this.cmsAuthInfos,
    required this.supportedLocales,
    this.getCmsUserInfos,
    this.cmsTexts = const CmsTexts(),
    this.cmsCustomMenuEntries = const [],
    this.cmsUnauthorizedRoutes = const [],
    this.lightTheme,
    this.darkTheme,
  });

  @override
  Widget build(BuildContext context) {
    final authStateService = AuthStateService(cmsAuthInfos);

    final router = getGoRouter(
      cmsAuthInfos: cmsAuthInfos,
      getCmsObjectStructures: getCmsObjectStructures,
      authStateService: authStateService,
      cmsCustomMenuEntries: cmsCustomMenuEntries,
      cmsUnauthorizedRoutes: cmsUnauthorizedRoutes,
      cmsTexts: cmsTexts,
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
        title: cmsTexts.appTitle,
        builder: (context, child1) => AnimatedBuilder(
          animation: authStateService,
          child: child1,
          builder: (context, child) {
            if (!authStateService.isInitialized) {
              return const SizedBox();
            } else {
              return authStateService.isLoggedIn
                  ? _CmsObjectsInherited(
                      cmsObjectStructures: getCmsObjectStructures(authStateService.loggedInUser!),
                      cmsAuthInfos: cmsAuthInfos,
                      authStateService: authStateService,
                      cmsCustomMenuEntries: cmsCustomMenuEntries,
                      cmsUserInfos: getCmsUserInfos?.call(authStateService.loggedInUser!),
                      cmsTexts: cmsTexts,
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

  static CmsUserInfos? getUserInfos(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_CmsObjectsInherited>()!.cmsUserInfos;
  }

  static AuthStateService getAuthStateService(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_CmsObjectsInherited>()!.authStateService;
  }

  static CmsAuthInfos getCmsAuthInfos(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_CmsObjectsInherited>()!.cmsAuthInfos;
  }

  static List<CmsObjectStructure> getAllCmsObjectStructures(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_CmsObjectsInherited>()!.cmsObjectStructures;
  }

  static List<CmsCustomMenuEntry> getCmsCustomMenuEntries(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_CmsObjectsInherited>()!.cmsCustomMenuEntries;
  }

  static CmsTexts getCmsTexts(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_CmsObjectsInherited>()!.cmsTexts;
  }

  static CmsObjectStructure? getCmsObjectStructureById({
    required BuildContext context,
    required String cmsObjectId,
  }) {
    final allCmsObjectStructures = getAllCmsObjectStructures(context);
    return allCmsObjectStructures.firstWhereOrNull((object) => object.id.toLowerCase() == cmsObjectId.toLowerCase());
  }
}

class _CmsObjectsInherited extends InheritedWidget {
  final List<CmsObjectStructure> cmsObjectStructures;
  final List<CmsCustomMenuEntry> cmsCustomMenuEntries;
  final CmsAuthInfos cmsAuthInfos;
  final AuthStateService authStateService;
  final CmsUserInfos? cmsUserInfos;
  final CmsTexts cmsTexts;

  _CmsObjectsInherited({
    required this.cmsObjectStructures,
    required this.cmsCustomMenuEntries,
    required this.cmsAuthInfos,
    required this.authStateService,
    required this.cmsUserInfos,
    required this.cmsTexts,
    required super.child,
  }) : assert(
          cmsObjectStructures.every(
            (object) => cmsObjectStructures.every(
              (otherObject) => object.id != otherObject.id || object == otherObject,
            ),
          ),
          'There are two objects with the same id',
        );

  @override
  bool updateShouldNotify(_CmsObjectsInherited oldWidget) {
    return cmsObjectStructures != oldWidget.cmsObjectStructures ||
        cmsAuthInfos != oldWidget.cmsAuthInfos ||
        cmsCustomMenuEntries != oldWidget.cmsCustomMenuEntries ||
        cmsUserInfos != oldWidget.cmsUserInfos ||
        cmsTexts != oldWidget.cmsTexts ||
        authStateService != oldWidget.authStateService;
  }
}
