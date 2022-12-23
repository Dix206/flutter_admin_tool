import 'package:flutter/material.dart';
import 'package:flutter_cms/routes.dart';
import 'package:flutter_cms/ui/cms_object_overview/cms_object_overview.dart';
import 'package:flutter_cms/ui/flutter_cms_widget.dart';
import 'package:go_router/go_router.dart';

class OverviewScreen extends StatelessWidget {
  final String selectedCmsObjectName;

  const OverviewScreen({
    Key? key,
    required this.selectedCmsObjectName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cmsObjects = FlutterCms.getAllObjects(context);
    final selectedCmsObject = FlutterCms.getObjectByName(
      context: context,
      cmsObjectName: selectedCmsObjectName,
    );

    return Scaffold(
      body: Row(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cmsObjects.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(cmsObjects[index].name),
                  onTap: () => context.go(Routes.overview(cmsObjects[index].name)),
                );
              },
            ),
          ),
          Expanded(
            flex: 3,
            child: selectedCmsObject == null
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("There is no Object with the name $selectedCmsObjectName"),
                    ),
                  )
                : CmsObjectOverview(
                    cmsObject: selectedCmsObject,
                  ),
          ),
        ],
      ),
    );
  }
}
