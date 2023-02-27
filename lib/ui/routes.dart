import 'package:flutter/material.dart';
import 'package:flat/data_types/flat_texts.dart';
import 'package:flat/data_types/flat_unauthorized_route.dart';
import 'package:flat/ui/auth_state_service.dart';
import 'package:flat/data_types/flat_object_sort_options.dart';
import 'package:flat/data_types/flat_custom_menu_entry.dart';
import 'package:flat/extensions/iterable_extensions.dart';
import 'package:flat/flat_app.dart';
import 'package:flat/data_types/flat_auth_infos.dart';
import 'package:flat/ui/screens/flat_main_screen.dart';
import 'package:flat/ui/screens/overview/overview_screen.dart';
import 'package:flat/ui/screens/settings/settings_screen.dart';
import 'package:flat/ui/screens/insert_flat_object/insert_flat_object_screen.dart';
import 'package:go_router/go_router.dart';

/// T is the type of the logged in user
GoRouter getGoRouter<T extends Object>({
  required FlatAuthInfos<T> flatAuthInfos,
  required GetFlatObjectStructures<T> getFlatObjectStructures,
  required AuthStateService<T> authStateService,
  required List<FlatCustomMenuEntry> flatCustomMenuEntries,
  required List<FlatUnauthorizedRoute> flatUnauthorizedRoutes,
  required FlatTexts flatTexts,
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
          flatObjectId: getFlatObjectStructures(authStateService.loggedInUser!).first.id,
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
      ...flatUnauthorizedRoutes.map(
        (flatUnauthorizedRoute) => FadeRoute(
          path: flatUnauthorizedRoute.path,
          childBuilder: flatUnauthorizedRoute.pageBuilder,
        ),
      ),
      FadeRoute(
        path: Routes.login,
        childBuilder: (context, state) => flatAuthInfos.loginScreenBuilder(
          authStateService.onUserLoggedIn,
        ),
      ),
      ShellRoute(
        builder: (context, state, child) {
          final flatObjectId = state.params['flatObjectId'];
          final customMenuEntryId = state.params['customMenuEntryId'];
          final mainScreenTab = state.location == Routes.settings
              ? FlatMainScreenTab.settings
              : state.location.startsWith("/custom/")
                  ? FlatMainScreenTab.custom
                  : FlatMainScreenTab.overview;

          return FlatMainScreen(
            selectedFlatObjectId: flatObjectId,
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
          ...flatCustomMenuEntries.map(
            (customMenuEntry) => FadeRoute(
              path: "/custom/:customMenuEntryId",
              childBuilder: (context, state) {
                final customMenuEntryId = state.params['customMenuEntryId'];
                final customMenuEntry = flatCustomMenuEntries.firstWhereOrNull(
                  (entry) => entry.id == customMenuEntryId,
                );

                return customMenuEntry?.contentBuilder(context) ??
                    Center(
                      child: Text(flatTexts.noFlatCustomMenuEntryFoundWithId),
                    );
              },
            ),
          ),
          FadeRoute(
            path: "/overview/:flatObjectId",
            childBuilder: (context, state) {
              final flatObjectId = state.params['flatObjectId'] ?? "";
              final searchQuery = state.queryParams['searchQuery'];
              final pageString = state.queryParams['page'] ?? "1";
              final sortAttributeId = state.queryParams['sortAttribute'];
              final sortAscending = state.queryParams['sortAscending'] == "true";

              return OverviewScreen(
                selectedFlatObjectId: flatObjectId,
                searchQuery: searchQuery,
                page: int.tryParse(pageString) ?? 1,
                sortOptions: sortAttributeId == null
                    ? null
                    : FlatObjectSortOptions(
                        attributeId: sortAttributeId,
                        ascending: sortAscending,
                      ),
              );
            },
          ),
          FadeRoute(
            path: "/overview/:flatObjectId/create",
            childBuilder: (context, state) {
              final flatObjectId = state.params['flatObjectId'] ?? "";
              final searchQuery = state.queryParams['searchQuery'];
              final pageString = state.queryParams['page'] ?? "";
              final sortAttributeId = state.queryParams['sortAttribute'];
              final sortAscending = state.queryParams['sortAscending'] == "true";

              return InsertFlatObjectScreen(
                flatObjectId: flatObjectId,
                existingFlatObjectValueId: null,
                searchQuery: searchQuery,
                page: int.tryParse(pageString),
                sortOptions: sortAttributeId == null
                    ? null
                    : FlatObjectSortOptions(
                        attributeId: sortAttributeId,
                        ascending: sortAscending,
                      ),
              );
            },
          ),
          FadeRoute(
            path: "/overview/:flatObjectId/update/:existingFlatObjectValueId",
            childBuilder: (context, state) {
              final flatObjectId = state.params['flatObjectId'] ?? "";
              final existingFlatObjectValueId = state.params['existingFlatObjectValueId'];
              final searchQuery = state.queryParams['searchQuery'];
              final pageString = state.queryParams['page'] ?? "";
              final sortAttributeId = state.queryParams['sortAttribute'];
              final sortAscending = state.queryParams['sortAscending'] == "true";

              return InsertFlatObjectScreen(
                flatObjectId: flatObjectId,
                existingFlatObjectValueId: existingFlatObjectValueId,
                searchQuery: searchQuery,
                page: int.tryParse(pageString),
                sortOptions: sortAttributeId == null
                    ? null
                    : FlatObjectSortOptions(
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
    required String flatObjectId,
    required String? searchQuery,
    required int page,
    required FlatObjectSortOptions? sortOptions,
  }) {
    final searchQueryPath = searchQuery == null ? "" : "&searchQuery=$searchQuery";
    final sortOptionsPath =
        sortOptions == null ? "" : "&sortAttribute=${sortOptions.attributeId}&sortAscending=${sortOptions.ascending}";
    return "/overview/$flatObjectId?page=$page$searchQueryPath$sortOptionsPath";
  }

  static updateObject({
    required String flatObjectId,
    required Object existingFlatObjectValueId,
    required String? searchQuery,
    required int? page,
    required FlatObjectSortOptions? sortOptions,
  }) {
    final pagePath = "?page=$page";
    final searchQueryPath = searchQuery == null ? "" : "&searchQuery=$searchQuery";
    final sortOptionsPath =
        sortOptions == null ? "" : "&sortAttribute=${sortOptions.attributeId}&sortAscending=${sortOptions.ascending}";

    return "/overview/$flatObjectId/update/$existingFlatObjectValueId$pagePath$searchQueryPath$sortOptionsPath";
  }

  static createObject({
    required String flatObjectId,
    required String? searchQuery,
    required int? page,
    required FlatObjectSortOptions? sortOptions,
  }) {
    final pagePath = "?page=$page";
    final searchQueryPath = searchQuery == null ? "" : "&searchQuery=$searchQuery";
    final sortOptionsPath =
        sortOptions == null ? "" : "&sortAttribute=${sortOptions.attributeId}&sortAscending=${sortOptions.ascending}";

    return "/overview/$flatObjectId/create$pagePath$searchQueryPath$sortOptionsPath";
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
