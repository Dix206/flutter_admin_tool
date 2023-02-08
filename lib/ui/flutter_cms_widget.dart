import 'package:flutter/material.dart';
import 'package:flutter_cms/data_types/cms_object_structure.dart';
import 'package:flutter_cms/models/navigation_infos.dart';
import 'package:flutter_cms/routes.dart';

class FlutterCms extends StatelessWidget {
  final List<CmsObjectStructure> cmsObjects;
  final CmsAuthInfos cmsAuthInfos;

  const FlutterCms({
    Key? key,
    required this.cmsObjects,
    required this.cmsAuthInfos,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final router = getGoRouter(
      cmsAuthInfos: cmsAuthInfos,
      cmsOnjects: cmsObjects,
    );

    return MaterialApp.router(
      routeInformationProvider: router.routeInformationProvider,
      routerDelegate: router.routerDelegate,
      routeInformationParser: router.routeInformationParser,
      title: "asdasd",
      builder: (context, child) => _CmsObjectsInherited(
        cmsObjects: cmsObjects,
        child: child!,
      ),
    );
  }

  static List<CmsObjectStructure> getAllObjects(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_CmsObjectsInherited>()!.cmsObjects;
  }

  static CmsObjectStructure? getObjectByName({
    required BuildContext context,
    required String cmsObjectName,
  }) {
    final allObjects = getAllObjects(context);
    for (final object in allObjects) {
      if (object.displayName == cmsObjectName) return object;
    }

    return null;
  }
}

class _CmsObjectsInherited extends InheritedWidget {
  final List<CmsObjectStructure> cmsObjects;

  const _CmsObjectsInherited({
    required this.cmsObjects,
    required super.child,
  });

  @override
  bool updateShouldNotify(_CmsObjectsInherited oldWidget) {
    return cmsObjects != oldWidget.cmsObjects;
  }
}
