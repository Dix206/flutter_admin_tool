import 'package:flutter/material.dart';
import 'package:flutter_cms/data_types/cms_object_structure.dart';
import 'package:flutter_cms/extensions/iterable_extensions.dart';
import 'package:flutter_cms/models/navigation_infos.dart';
import 'package:flutter_cms/routes.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class FlutterCms extends StatelessWidget {
  final List<CmsObjectStructure> cmsObjects;
  final CmsAuthInfos cmsAuthInfos;
  final List<Locale> supportedLocales;

  FlutterCms({
    Key? key,
    required this.cmsObjects,
    required this.cmsAuthInfos,
    required this.supportedLocales,
  })  : assert(
          cmsObjects.every(
            (object) => cmsObjects.every(
              (otherObject) => object.id != otherObject.id || object == otherObject,
            ),
          ),
          'There are two objects with the same id',
        ),
        super(key: key);

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
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: supportedLocales,
    );
  }

  static List<CmsObjectStructure> getAllObjects(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_CmsObjectsInherited>()!.cmsObjects;
  }

  static CmsObjectStructure? getObjectById({
    required BuildContext context,
    required String cmsObjectId,
  }) {
    final allObjects = getAllObjects(context);
    return allObjects.firstWhereOrNull((object) => object.id.toLowerCase() == cmsObjectId.toLowerCase());
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
