import 'package:flutter/material.dart';
import 'package:flutter_cms/auth_state_service.dart';
import 'package:flutter_cms/data_types/cms_object_sort_options.dart';
import 'package:flutter_cms/data_types/cms_object_structure.dart';
import 'package:flutter_cms/data_types/cms_custom_menu_entry.dart';
import 'package:flutter_cms/extensions/iterable_extensions.dart';
import 'package:flutter_cms/models/navigation_infos.dart';
import 'package:flutter_cms/ui/screens/main_screen.dart';
import 'package:flutter_cms/ui/screens/overview/overview_screen.dart';
import 'package:flutter_cms/ui/screens/settings/settings_screen.dart';
import 'package:flutter_cms/ui/screens/insert_cms_object/insert_cms_object_screen.dart';
import 'package:flutter_cms/ui/widgets/cms_loading.dart';
import 'package:go_router/go_router.dart';

GoRouter getGoRouter({
  required CmsAuthInfos cmsAuthInfos,
  required List<CmsObjectStructure> cmsObjects,
  required AuthStateService authStateService,
  required List<CmsCustomMenuEntry> customMenuEntries,
}) {
  return GoRouter(
    initialLocation: Routes.login,
    refreshListenable: authStateService,
    redirect: (context, state) async {
      final isLoginRoute = state.subloc == Routes.login;

      if (!authStateService.isInitialized) {
        return null;
      } else if (authStateService.isLoggedIn && isLoginRoute) {
        return Routes.overview(
          cmsObjectId: cmsObjects.first.id,
          page: 1,
          searchQuery: null,
          sortOptions: null,
        );
      } else if (!authStateService.isLoggedIn) {
        return Routes.login;
      } else {
        return null;
      }
    },
    routes: [
      FadeRoute(
        path: Routes.login,
        authStateService: authStateService,
        childBuilder: (context, state) => cmsAuthInfos.loginScreenBuilder(
          authStateService.onUserLoggedIn,
        ),
      ),
      ShellRoute(
        builder: (context, state, child) {
          final cmsObjectId = state.params['cmsObjectId'];
          final customMenuEntryId = state.params['customMenuEntryId'];
          final mainScreenTab = state.location == Routes.settings
              ? MainScreenTab.settings
              : state.location.startsWith("/custom/")
                  ? MainScreenTab.custom
                  : MainScreenTab.overview;

          return MainScreen(
            selectedCmsObjectId: cmsObjectId,
            selectedCustomMenuEntryId: customMenuEntryId,
            selectedTab: mainScreenTab,
            child: child,
          );
        },
        routes: [
          FadeRoute(
            path: Routes.settings,
            authStateService: authStateService,
            childBuilder: (context, state) {
              return const SettingsScreen();
            },
          ),
          ...customMenuEntries.map(
            (customMenuEntry) => FadeRoute(
              path: "/custom/:customMenuEntryId",
              authStateService: authStateService,
              childBuilder: (context, state) {
                final customMenuEntryId = state.params['customMenuEntryId'];
                final customMenuEntry = customMenuEntries.firstWhereOrNull(
                  (entry) => entry.id == customMenuEntryId,
                );

                return customMenuEntry?.contentBuilder(context) ??
                    const Center(
                      child: Text("There is no custom menu entry with id"),
                    );
              },
            ),
          ),
          FadeRoute(
            path: "/overview/:cmsObjectId",
            authStateService: authStateService,
            childBuilder: (context, state) {
              final cmsObjectId = state.params['cmsObjectId'] ?? "";
              final searchQuery = state.queryParams['searchQuery'];
              final pageString = state.queryParams['page'] ?? "1";
              final sortAttributId = state.queryParams['sortAttribut'];
              final sortAscending = state.queryParams['sortAscending'] == "true";

              return OverviewScreen(
                selectedCmsObjectId: cmsObjectId,
                searchQuery: searchQuery,
                page: int.tryParse(pageString) ?? 1,
                sortOptions: sortAttributId == null
                    ? null
                    : CmsObjectSortOptions(
                        attributId: sortAttributId,
                        ascending: sortAscending,
                      ),
              );
            },
          ),
          FadeRoute(
            path: "/overview/:cmsObjectId/create",
            authStateService: authStateService,
            childBuilder: (context, state) {
              final cmsObjectId = state.params['cmsObjectId'] ?? "";
              final searchQuery = state.queryParams['searchQuery'];
              final pageString = state.queryParams['page'] ?? "";
              final sortAttributId = state.queryParams['sortAttribut'];
              final sortAscending = state.queryParams['sortAscending'] == "true";

              return InsertCmsObjectScreen(
                cmsObjectId: cmsObjectId,
                existingCmsObjectValueId: null,
                searchQuery: searchQuery,
                page: int.tryParse(pageString),
                sortOptions: sortAttributId == null
                    ? null
                    : CmsObjectSortOptions(
                        attributId: sortAttributId,
                        ascending: sortAscending,
                      ),
              );
            },
          ),
          FadeRoute(
            path: "/overview/:cmsObjectId/update/:existingCmsObjectValueId",
            authStateService: authStateService,
            childBuilder: (context, state) {
              final cmsObjectId = state.params['cmsObjectId'] ?? "";
              final existingCmsObjectValueId = state.params['existingCmsObjectValueId'];
              final searchQuery = state.queryParams['searchQuery'];
              final pageString = state.queryParams['page'] ?? "";
              final sortAttributId = state.queryParams['sortAttribut'];
              final sortAscending = state.queryParams['sortAscending'] == "true";

              return InsertCmsObjectScreen(
                cmsObjectId: cmsObjectId,
                existingCmsObjectValueId: existingCmsObjectValueId,
                searchQuery: searchQuery,
                page: int.tryParse(pageString),
                sortOptions: sortAttributId == null
                    ? null
                    : CmsObjectSortOptions(
                        attributId: sortAttributId,
                        ascending: sortAscending,
                      ),
              );
            },
          ),
        ],
      ),
    ],
  );
}

class Routes {
  static String login = "/login";
  static String settings = "/settings";
  static customMenuEntry(String customMenuEntryId) => "/custom/$customMenuEntryId";
  static overview({
    required String cmsObjectId,
    required String? searchQuery,
    required int page,
    required CmsObjectSortOptions? sortOptions,
  }) {
    final searchQueryPath = searchQuery == null ? "" : "&searchQuery=$searchQuery";
    final sortOptionsPath =
        sortOptions == null ? "" : "&sortAttribut=${sortOptions.attributId}&sortAscending=${sortOptions.ascending}";
    return "/overview/$cmsObjectId?page=$page$searchQueryPath$sortOptionsPath";
  }

  static updateObject({
    required String cmsObjectId,
    required Object existingCmsObjectValueId,
    required String? searchQuery,
    required int? page,
    required CmsObjectSortOptions? sortOptions,
  }) {
    final pagePath = "?page=$page";
    final searchQueryPath = searchQuery == null ? "" : "&searchQuery=$searchQuery";
    final sortOptionsPath =
        sortOptions == null ? "" : "&sortAttribut=${sortOptions.attributId}&sortAscending=${sortOptions.ascending}";

    return "/overview/$cmsObjectId/update/$existingCmsObjectValueId$pagePath$searchQueryPath$sortOptionsPath";
  }

  static createObject({
    required String cmsObjectId,
    required String? searchQuery,
    required int? page,
    required CmsObjectSortOptions? sortOptions,
  }) {
    final pagePath = "?page=$page";
    final searchQueryPath = searchQuery == null ? "" : "&searchQuery=$searchQuery";
    final sortOptionsPath =
        sortOptions == null ? "" : "&sortAttribut=${sortOptions.attributId}&sortAscending=${sortOptions.ascending}";

    return "/overview/$cmsObjectId/create$pagePath$searchQueryPath$sortOptionsPath";
  }
}

class FadeRoute extends GoRoute {
  FadeRoute({
    required super.path,
    super.name,
    required Widget Function(BuildContext, GoRouterState) childBuilder,
    List<GoRoute> super.routes = const [],
    Future<String?> Function(BuildContext, GoRouterState)? redirect,
    required AuthStateService authStateService,
  }) : super(
          pageBuilder: (context, state) => CustomTransitionPage<void>(
            key: state.pageKey,
            transitionsBuilder: (context, animation, secondaryAnimation, child) => FadeTransition(
              opacity: animation,
              child: child,
            ),
            child: _LoadingScreen(
              screen: childBuilder(context, state),
              authStateService: authStateService,
            ),
          ),
        );
}

class _LoadingScreen extends StatelessWidget {
  final Widget screen;
  final AuthStateService authStateService;

  const _LoadingScreen({
    required this.screen,
    required this.authStateService,
  });

  @override
  Widget build(BuildContext context) {
    if (authStateService.isInitialized) {
      return screen;
    } else {
      return const Scaffold(
        body: CmsLoading(),
      );
    }
  }
}
