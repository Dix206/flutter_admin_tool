import 'package:flutter/material.dart';
import 'package:flutter_cms/ui/screens/overview/cms_object_overview.dart';
import 'package:flutter_cms/ui/flutter_cms_widget.dart';

class OverviewScreen extends StatelessWidget {
  final String selectedCmsObjectName;

  const OverviewScreen({
    Key? key,
    required this.selectedCmsObjectName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final selectedCmsObject = FlutterCms.getObjectByName(
      context: context,
      cmsObjectName: selectedCmsObjectName,
    );

    return selectedCmsObject == null
        ? Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("There is no Object with the name $selectedCmsObjectName"),
            ),
          )
        : CmsObjectOverview(
            cmsObject: selectedCmsObject,
          );
  }
}
