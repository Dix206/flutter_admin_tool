import 'package:flutter/material.dart';
import 'package:flutter_cms/data_types/cms_object_sort_options.dart';
import 'package:flutter_cms/ui/screens/overview/cms_object_overview.dart';
import 'package:flutter_cms/flutter_cms.dart';

class OverviewScreen extends StatelessWidget {
  final String selectedCmsObjectId;
  final String? searchQuery;
  final int page;
  final CmsObjectSortOptions? sortOptions;

  const OverviewScreen({
    Key? key,
    required this.selectedCmsObjectId,
    required this.searchQuery,
    required this.page,
    required this.sortOptions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final selectedCmsObjectStructure = FlutterCms.getCmsObjectStructureById(
      context: context,
      cmsObjectId: selectedCmsObjectId,
    );

    return selectedCmsObjectStructure == null
        ? Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("There is no Object with the id $selectedCmsObjectId"),
            ),
          )
        : CmsObjectOverview(
            cmsObject: selectedCmsObjectStructure,
            searchQuery: searchQuery,
            page: page,
            sortOptions: sortOptions,
          );
  }
}
