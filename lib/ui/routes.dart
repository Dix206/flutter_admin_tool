import 'package:flutter/material.dart';
import 'package:flutter_admin_tool/data_types/flat_texts.dart';
import 'package:flutter_admin_tool/data_types/flat_unauthorized_route.dart';
import 'package:flutter_admin_tool/ui/auth_state_service.dart';
import 'package:flutter_admin_tool/data_types/flat_object_sort_options.dart';
import 'package:flutter_admin_tool/data_types/flat_custom_menu_entry.dart';
import 'package:flutter_admin_tool/extensions/iterable_extensions.dart';
import 'package:flutter_admin_tool/flat_app.dart';
import 'package:flutter_admin_tool/data_types/flat_auth_infos.dart';
import 'package:flutter_admin_tool/ui/screens/flat_main_screen.dart';
import 'package:flutter_admin_tool/ui/screens/overview/overview_screen.dart';
import 'package:flutter_admin_tool/ui/screens/settings/settings_screen.dart';
import 'package:flutter_admin_tool/ui/screens/insert_flat_object/insert_flat_object_screen.dart';
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
      final isAuthRoute =
          state.uri.toString().startsWith(Routes.settings) == true ||
              state.uri.toString().startsWith("/custom") == true ||
              state.uri.toString().startsWith("/overview") == true;

      if (!authStateService.isInitialized) {
        return null;
      } else if (authStateService.isLoggedIn && !isAuthRoute) {
        return Routes.overview(
          flatObjectId:
              getFlatObjectStructures(authStateService.loggedInUser!).first.id,
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
          final flatObjectId = state.pathParameters['flatObjectId'];
          final customMenuEntryId = state.pathParameters['customMenuEntryId'];
          final mainScreenTab = state.uri.toString() == Routes.settings
              ? FlatMainScreenTab.settings
              : state.uri.toString().startsWith("/custom/")
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
                final customMenuEntryId =
                    state.pathParameters['customMenuEntryId'];
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
              final flatObjectId = state.pathParameters['flatObjectId'] ?? "";
              final searchQuery = state.uri.queryParameters['searchQuery'];
              final pageString = state.uri.queryParameters['page'] ?? "1";
              final sortAttributeId =
                  state.uri.queryParameters['sortAttribute'];
              final sortAscending =
                  state.uri.queryParameters['sortAscending'] == "true";

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
              final flatObjectId = state.pathParameters['flatObjectId'] ?? "";
              final searchQuery = state.uri.queryParameters['searchQuery'];
              final pageString = state.uri.queryParameters['page'] ?? "";
              final sortAttributeId =
                  state.uri.queryParameters['sortAttribute'];
              final sortAscending =
                  state.uri.queryParameters['sortAscending'] == "true";

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
              final flatObjectId = state.pathParameters['flatObjectId'] ?? "";
              final existingFlatObjectValueId =
                  state.pathParameters['existingFlatObjectValueId'];
              final searchQuery = state.uri.queryParameters['searchQuery'];
              final pageString = state.uri.queryParameters['page'] ?? "";
              final sortAttributeId =
                  state.uri.queryParameters['sortAttribute'];
              final sortAscending =
                  state.uri.queryParameters['sortAscending'] == "true";

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
  static customMenuEntry(String customMenuEntryId) =>
      "/custom/$customMenuEntryId";
  static overview({
    required String flatObjectId,
    required String? searchQuery,
    required int page,
    required FlatObjectSortOptions? sortOptions,
  }) {
    final searchQueryPath =
        searchQuery == null ? "" : "&searchQuery=$searchQuery";
    final sortOptionsPath = sortOptions == null
        ? ""
        : "&sortAttribute=${sortOptions.attributeId}&sortAscending=${sortOptions.ascending}";
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
    final searchQueryPath =
        searchQuery == null ? "" : "&searchQuery=$searchQuery";
    final sortOptionsPath = sortOptions == null
        ? ""
        : "&sortAttribute=${sortOptions.attributeId}&sortAscending=${sortOptions.ascending}";

    return "/overview/$flatObjectId/update/$existingFlatObjectValueId$pagePath$searchQueryPath$sortOptionsPath";
  }

  static createObject({
    required String flatObjectId,
    required String? searchQuery,
    required int? page,
    required FlatObjectSortOptions? sortOptions,
  }) {
    final pagePath = "?page=$page";
    final searchQueryPath =
        searchQuery == null ? "" : "&searchQuery=$searchQuery";
    final sortOptionsPath = sortOptions == null
        ? ""
        : "&sortAttribute=${sortOptions.attributeId}&sortAscending=${sortOptions.ascending}";

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
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) =>
                    FadeTransition(
              opacity: animation,
              child: child,
            ),
            child: childBuilder(context, state),
          ),
        );
}
