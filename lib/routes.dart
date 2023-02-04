import 'package:flutter/material.dart';
import 'package:flutter_cms/data_types/cms_object.dart';
import 'package:flutter_cms/models/navigation_infos.dart';
import 'package:flutter_cms/ui/screens/overview/overview_screen.dart';
import 'package:go_router/go_router.dart';

import 'ui/screens/insert_cms_object/insert_cms_object.dart';

class AuthStateService with ChangeNotifier {
  final CmsAuthInfos _cmsAuthInfos;

  bool _isLoggedIn = false;
  bool _isInitialized = false;

  AuthStateService(
    this._cmsAuthInfos,
  ) {
    _init();
  }

  bool get isLoggedIn => _isLoggedIn;
  bool get isInitialized => _isInitialized;

  void onUserLoggedIn() {
    _isLoggedIn = true;
    notifyListeners();
  }

  Future<void> _init() async {
    _isLoggedIn = await _cmsAuthInfos.isUserLoggedIn();
    _isInitialized = true;
    notifyListeners();
  }
}

GoRouter getGoRouter({
  required CmsAuthInfos cmsAuthInfos,
  required List<CmsObject> cmsOnjects,
}) {
  final authStateService = AuthStateService(cmsAuthInfos);

  return GoRouter(
    initialLocation: Routes.login,
    refreshListenable: authStateService,
    redirect: (context, state) async {
      final isLoginRoute = state.subloc == Routes.login;

      if (!authStateService.isInitialized) {
        return null;
      } else if (authStateService.isLoggedIn && isLoginRoute) {
        return Routes.overview(cmsOnjects.first.name);
      } else if (!authStateService.isLoggedIn) {
        return Routes.login;
      } else {
        return null;
      }
    },
    routes: [
      GoRoute(
        path: Routes.login,
        builder: (context, state) => cmsAuthInfos.loginScreenBuilder(
          authStateService.onUserLoggedIn,
        ),
      ),
      GoRoute(
        path: "/overview/:cmsObjectName",
        builder: (context, state) {
          final cmsObjectName = state.params['cmsObjectName'] ?? "";
          return OverviewScreen(selectedCmsObjectName: cmsObjectName);
        },
        routes: [
          GoRoute(
            path: "create",
            builder: (context, state) {
              final cmsObjectName = state.params['cmsObjectName'] ?? "";

              return InsertCmsObject(
                cmsObjectName: cmsObjectName,
                existingCmsObjectValueId: null,
              );
            },
          ),
          GoRoute(
            path: "update/:existingCmsObjectValueId",
            builder: (context, state) {
              final cmsObjectName = state.params['cmsObjectName'] ?? "";
              final existingCmsObjectValueId = state.params['existingCmsObjectValueId'];
              return InsertCmsObject(
                cmsObjectName: cmsObjectName,
                existingCmsObjectValueId: existingCmsObjectValueId,
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
  static overview(String cmsObjectName) => "/overview/$cmsObjectName";
  static updateObject({
    required String cmsObjectName,
    required Object existingCmsObjectValueId,
  }) =>
      "/overview/$cmsObjectName/update/$existingCmsObjectValueId";
  static createObject(String cmsObjectName) => "/overview/$cmsObjectName/create";
}
