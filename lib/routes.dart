import 'package:flutter/material.dart';
import 'package:flutter_cms/data_types/cms_object_structure.dart';
import 'package:flutter_cms/models/navigation_infos.dart';
import 'package:flutter_cms/ui/screens/main_screen.dart';
import 'package:flutter_cms/ui/screens/overview/overview_screen.dart';
import 'package:flutter_cms/ui/widgets/cms_loading.dart';
import 'package:go_router/go_router.dart';

import 'ui/screens/insert_cms_object/insert_cms_object.dart';

GoRouter getGoRouter({
  required CmsAuthInfos cmsAuthInfos,
  required List<CmsObjectStructure> cmsOnjects,
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
        return Routes.overview(cmsOnjects.first.id);
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
        childBuilder: (state) => cmsAuthInfos.loginScreenBuilder(
          authStateService.onUserLoggedIn,
        ),
      ),
      ShellRoute(
        builder: (context, state, child) {
          final cmsObjectId = state.params['cmsObjectId'] ?? "";
          return MainScreen(
            selectedCmsObjectId: cmsObjectId,
            child: child,
          );
        },
        routes: [
          FadeRoute(
            path: "/overview/:cmsObjectId",
            authStateService: authStateService,
            childBuilder: (state) {
              final cmsObjectId = state.params['cmsObjectId'] ?? "";
              return OverviewScreen(selectedCmsObjectId: cmsObjectId);
            },
          ),
          FadeRoute(
            path: "/overview/:cmsObjectId/create",
            authStateService: authStateService,
            childBuilder: (state) {
              final cmsObjectId = state.params['cmsObjectId'] ?? "";

              return InsertCmsObject(
                cmsObjectId: cmsObjectId,
                existingCmsObjectValueId: null,
              );
            },
          ),
          FadeRoute(
            path: "/overview/:cmsObjectId/update/:existingCmsObjectValueId",
            authStateService: authStateService,
            childBuilder: (state) {
              final cmsObjectId = state.params['cmsObjectId'] ?? "";
              final existingCmsObjectValueId = state.params['existingCmsObjectValueId'];
              return InsertCmsObject(
                cmsObjectId: cmsObjectId,
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
    required String cmsObjectId,
    required Object existingCmsObjectValueId,
  }) =>
      "/overview/$cmsObjectId/update/$existingCmsObjectValueId";
  static createObject(String cmsObjectId) => "/overview/$cmsObjectId/create";
}

class FadeRoute extends GoRoute {
  FadeRoute({
    required super.path,
    super.name,
    required Widget Function(GoRouterState) childBuilder,
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
              screen: childBuilder(state),
              authStateService: authStateService,
            ),
          ),
        );
}

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
