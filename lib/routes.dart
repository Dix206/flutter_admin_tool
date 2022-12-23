import 'package:flutter_cms/data_types/cms_object.dart';
import 'package:flutter_cms/ui/overview/overview_screen.dart';
import 'package:go_router/go_router.dart';

import 'ui/insert_cms_object/insert_cms_object.dart';

GoRouter getGoRouter(CmsObject initialObject) => GoRouter(
      initialLocation: "/overview/${initialObject.name}",
      routes: [
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

class Routes {
  static overview(String cmsObjectName) => "/overview/$cmsObjectName";
  static updateObject({
    required String cmsObjectName,
    required Object existingCmsObjectValueId,
  }) =>
      "/overview/$cmsObjectName/update/$existingCmsObjectValueId";
  static createObject(String cmsObjectName) => "/overview/$cmsObjectName/create";
}
