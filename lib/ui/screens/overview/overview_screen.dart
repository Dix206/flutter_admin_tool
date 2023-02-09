import 'package:flutter/material.dart';
import 'package:flutter_cms/ui/screens/overview/cms_object_overview.dart';
import 'package:flutter_cms/ui/flutter_cms_widget.dart';

class OverviewScreen extends StatelessWidget {
  final String selectedCmsObjectId;
  final String? searchQuery;
  final int page;

  const OverviewScreen({
    Key? key,
    required this.selectedCmsObjectId,
    required this.searchQuery,
    required this.page,
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
            searchQuery: searchQuery,
            page: page,
          );
  }
}
