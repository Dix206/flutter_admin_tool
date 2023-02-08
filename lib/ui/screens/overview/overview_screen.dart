import 'package:flutter/material.dart';
import 'package:flutter_cms/ui/screens/overview/cms_object_overview.dart';
import 'package:flutter_cms/ui/flutter_cms_widget.dart';

class OverviewScreen extends StatelessWidget {
  final String selectedCmsObjectId;

  const OverviewScreen({
    Key? key,
    required this.selectedCmsObjectId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final selectedCmsObject = FlutterCms.getObjectById(
      context: context,
      cmsObjectId: selectedCmsObjectId,
    );

    return selectedCmsObject == null
        ? Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("There is no Object with the id $selectedCmsObjectId"),
            ),
          )
        : CmsObjectOverview(
            cmsObject: selectedCmsObject,
          );
  }
}
