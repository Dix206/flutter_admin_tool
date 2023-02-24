import 'package:flutter/material.dart';
import 'package:flutter_cms/data_types/cms_texts.dart';
import 'package:flutter_cms/data_types/cms_unauthorized_route.dart';
import 'package:flutter_cms/ui/auth_state_service.dart';
import 'package:flutter_cms/data_types/cms_object_sort_options.dart';
import 'package:flutter_cms/data_types/cms_custom_menu_entry.dart';
import 'package:flutter_cms/extensions/iterable_extensions.dart';
import 'package:flutter_cms/flutter_cms.dart';
import 'package:flutter_cms/data_types/navigation_infos.dart';
import 'package:flutter_cms/ui/screens/cms_main_screen.dart';
import 'package:flutter_cms/ui/screens/overview/overview_screen.dart';
import 'package:flutter_cms/ui/screens/settings/settings_screen.dart';
import 'package:flutter_cms/ui/screens/insert_cms_object/insert_cms_object_screen.dart';
import 'package:go_router/go_router.dart';

/// T is the type of the logged in user
GoRouter getGoRouter<T extends Object>({
  required CmsAuthInfos<T> cmsAuthInfos,
  required GetCmsObjectStructures<T> getCmsObjectStructures,
  required AuthStateService<T> authStateService,
  required List<CmsCustomMenuEntry> cmsCustomMenuEntries,
  required List<CmsUnauthorizedRoute> cmsUnauthorizedRoutes,
  required CmsTexts cmsTexts,
}) {
  return GoRouter(
    initialLocation: Routes.login,
    refreshListenable: authStateService,
    redirect: (context, state) async {
      final isAuthRoute = state.location.startsWith(Routes.settings) == true ||
          state.location.startsWith("/custom") == true ||
          state.location.startsWith("/overview") == true;

      if (!authStateService.isInitialized) {
        return null;
      } else if (authStateService.isLoggedIn && !isAuthRoute) {
        return Routes.overview(
          cmsObjectId: getCmsObjectStructures(authStateService.loggedInUser!).first.id,
          page: 1,
          searchQuery: null,
          sortOptions: null,
        );
      } else if (!authStateService.isLoggedIn && isAuthRoute) {
        return Routes.login;
      } else {
        return null;
      }
    },
    routes: [
      ...cmsUnauthorizedRoutes.map(
        (cmsUnauthorizedRoute) => FadeRoute(
          path: cmsUnauthorizedRoute.path,
          childBuilder: cmsUnauthorizedRoute.childBuilder,
        ),
      ),
      FadeRoute(
        path: Routes.login,
        childBuilder: (context, state) => cmsAuthInfos.loginScreenBuilder(
          authStateService.onUserLoggedIn,
        ),
      ),
      ShellRoute(
        builder: (context, state, child) {
          final cmsObjectId = state.params['cmsObjectId'];
          final customMenuEntryId = state.params['customMenuEntryId'];
          final mainScreenTab = state.location == Routes.settings
              ? CmsMainScreenTab.settings
              : state.location.startsWith("/custom/")
                  ? CmsMainScreenTab.custom
                  : CmsMainScreenTab.overview;

          return CmsMainScreen(
            selectedCmsObjectId: cmsObjectId,
            selectedCustomMenuEntryId: customMenuEntryId,
            selectedTab: mainScreenTab,
            child: child,
          );
        },
        routes: [
          FadeRoute(
            path: Routes.settings,
            childBuilder: (context, state) {
              return const SettingsScreen();
            },
          ),
          ...cmsCustomMenuEntries.map(
            (customMenuEntry) => FadeRoute(
              path: "/custom/:customMenuEntryId",
              childBuilder: (context, state) {
                final customMenuEntryId = state.params['customMenuEntryId'];
                final customMenuEntry = cmsCustomMenuEntries.firstWhereOrNull(
                  (entry) => entry.id == customMenuEntryId,
                );

                return customMenuEntry?.contentBuilder(context) ??
                    Center(
                      child: Text(cmsTexts.noCmsCustomMenuEntryFoundWithId),
                    );
              },
            ),
          ),
          FadeRoute(
            path: "/overview/:cmsObjectId",
            childBuilder: (context, state) {
              final cmsObjectId = state.params['cmsObjectId'] ?? "";
              final searchQuery = state.queryParams['searchQuery'];
              final pageString = state.queryParams['page'] ?? "1";
              final sortAttributeId = state.queryParams['sortAttribute'];
              final sortAscending = state.queryParams['sortAscending'] == "true";

              return OverviewScreen(
                selectedCmsObjectId: cmsObjectId,
                searchQuery: searchQuery,
                page: int.tryParse(pageString) ?? 1,
                sortOptions: sortAttributeId == null
                    ? null
                    : CmsObjectSortOptions(
                        attributeId: sortAttributeId,
                        ascending: sortAscending,
                      ),
              );
            },
          ),
          FadeRoute(
            path: "/overview/:cmsObjectId/create",
            childBuilder: (context, state) {
              final cmsObjectId = state.params['cmsObjectId'] ?? "";
              final searchQuery = state.queryParams['searchQuery'];
              final pageString = state.queryParams['page'] ?? "";
              final sortAttributeId = state.queryParams['sortAttribute'];
              final sortAscending = state.queryParams['sortAscending'] == "true";

              return InsertCmsObjectScreen(
                cmsObjectId: cmsObjectId,
                existingCmsObjectValueId: null,
                searchQuery: searchQuery,
                page: int.tryParse(pageString),
                sortOptions: sortAttributeId == null
                    ? null
                    : CmsObjectSortOptions(
                        attributeId: sortAttributeId,
                        ascending: sortAscending,
                      ),
              );
            },
          ),
          FadeRoute(
            path: "/overview/:cmsObjectId/update/:existingCmsObjectValueId",
            childBuilder: (context, state) {
              final cmsObjectId = state.params['cmsObjectId'] ?? "";
              final existingCmsObjectValueId = state.params['existingCmsObjectValueId'];
              final searchQuery = state.queryParams['searchQuery'];
              final pageString = state.queryParams['page'] ?? "";
              final sortAttributeId = state.queryParams['sortAttribute'];
              final sortAscending = state.queryParams['sortAscending'] == "true";

              return InsertCmsObjectScreen(
                cmsObjectId: cmsObjectId,
                existingCmsObjectValueId: existingCmsObjectValueId,
                searchQuery: searchQuery,
                page: int.tryParse(pageString),
                sortOptions: sortAttributeId == null
                    ? null
                    : CmsObjectSortOptions(
                        attributeId: sortAttributeId,
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
        sortOptions == null ? "" : "&sortAttribute=${sortOptions.attributeId}&sortAscending=${sortOptions.ascending}";
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
        sortOptions == null ? "" : "&sortAttribute=${sortOptions.attributeId}&sortAscending=${sortOptions.ascending}";

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
        sortOptions == null ? "" : "&sortAttribute=${sortOptions.attributeId}&sortAscending=${sortOptions.ascending}";

    return "/overview/$cmsObjectId/create$pagePath$searchQueryPath$sortOptionsPath";
  }
}

/// T is the type of the logged in user
class FadeRoute<T extends Object> extends GoRoute {
  FadeRoute({
    required super.path,
    super.name,
    required Widget Function(BuildContext, GoRouterState) childBuilder,
    List<GoRoute> super.routes = const [],
    Future<String?> Function(BuildContext, GoRouterState)? redirect,
  }) : super(
          pageBuilder: (context, state) => CustomTransitionPage<void>(
            key: state.pageKey,
            transitionsBuilder: (context, animation, secondaryAnimation, child) => FadeTransition(
              opacity: animation,
              child: child,
            ),
            child: childBuilder(context, state),
          ),
        );
}
