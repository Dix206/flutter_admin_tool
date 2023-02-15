import 'package:flutter/material.dart';
import 'package:flutter_cms/auth_state_service.dart';
import 'package:flutter_cms/data_types/cms_object_structure.dart';
import 'package:flutter_cms/extensions/iterable_extensions.dart';
import 'package:flutter_cms/data_types/navigation_infos.dart';
import 'package:flutter_cms/routes.dart';
import 'package:flutter_cms/ui/theme_mode_handler.dart';
import 'package:flutter_cms/data_types/cms_custom_menu_entry.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

/// This method will return a list of all cms object structures based on the passed user object which is of type T
typedef GetCmsObjectStructures<T extends Object> = List<CmsObjectStructure> Function(T loggedInUser);

/// T is the type of the logged in user
class FlutterCms<T extends Object> extends StatelessWidget {
  final GetCmsObjectStructures<T> getCmsObjectStructures;
  final CmsAuthInfos<T> cmsAuthInfos;
  final List<Locale> supportedLocales;
  final List<CmsCustomMenuEntry> customMenuEntries;
  final ThemeData? lightTheme;
  final ThemeData? darkTheme;

  const FlutterCms({
    super.key,
    required this.getCmsObjectStructures,
    required this.cmsAuthInfos,
    required this.supportedLocales,
    this.customMenuEntries = const [],
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
      customMenuEntries: customMenuEntries,
      screenBuilder: ({
        required BuildContext context,
        required List<CmsObjectStructure> cmsObjectStructures,
        required Widget screen,
      }) =>
          _CmsObjectsInherited(
        cmsObjectStructures: cmsObjectStructures,
        cmsAuthInfos: cmsAuthInfos,
        authStateService: authStateService,
        customMenuEntries: customMenuEntries,
        child: screen,
      ),
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
        title: "flutter cms",
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: supportedLocales,
      ),
    );
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

  static List<CmsCustomMenuEntry> getCustomMenuEntries(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_CmsObjectsInherited>()!.customMenuEntries;
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
  final List<CmsCustomMenuEntry> customMenuEntries;
  final CmsAuthInfos cmsAuthInfos;
  final AuthStateService authStateService;

  const _CmsObjectsInherited({
    required this.cmsObjectStructures,
    required this.customMenuEntries,
    required this.cmsAuthInfos,
    required this.authStateService,
    required super.child,
  });

  @override
  bool updateShouldNotify(_CmsObjectsInherited oldWidget) {
    return cmsObjectStructures != oldWidget.cmsObjectStructures ||
        cmsAuthInfos != oldWidget.cmsAuthInfos ||
        customMenuEntries != oldWidget.customMenuEntries ||
        authStateService != oldWidget.authStateService;
  }
}
