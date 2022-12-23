import 'package:flutter/material.dart';
import 'package:flutter_cms/data_types/cms_object.dart';
import 'package:flutter_cms/routes.dart';

class FlutterCms extends StatelessWidget {
  final List<CmsObject> cmsObjects;

  const FlutterCms({
    Key? key,
    required this.cmsObjects,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final router = getGoRouter(cmsObjects.first);

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

  static List<CmsObject> getAllObjects(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_CmsObjectsInherited>()!.cmsObjects;
  }

  static CmsObject? getObjectByName({
    required BuildContext context,
    required String cmsObjectName,
  }) {
    final allObjects = getAllObjects(context);
    for (final object in allObjects) {
      if (object.name == cmsObjectName) return object;
    }

    return null;
  }
}

class _CmsObjectsInherited extends InheritedWidget {
  final List<CmsObject> cmsObjects;

  const _CmsObjectsInherited({
    required this.cmsObjects,
    required super.child,
  });

  @override
  bool updateShouldNotify(_CmsObjectsInherited oldWidget) {
    return cmsObjects != oldWidget.cmsObjects;
  }
}
