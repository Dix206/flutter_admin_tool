import 'package:flutter/material.dart';
import 'package:flutter_cms/data_types/cms_object_sort_options.dart';
import 'package:flutter_cms/data_types/cms_object_structure.dart';
import 'package:flutter_cms/ui/screens/overview/widgets/cms_object_overview_actions.dart';
import 'package:flutter_cms/ui/screens/overview/widgets/cms_object_overview_pagination.dart';
import 'package:flutter_cms/ui/screens/overview/widgets/cms_object_overview_table.dart';
import 'package:flutter_cms/ui/widgets/cms_top_bar.dart';

class CmsObjectOverview extends StatefulWidget {
  final CmsObjectStructure cmsObject;
  final String? searchQuery;
  final int page;
  final CmsObjectSortOptions? sortOptions;

  const CmsObjectOverview({
    Key? key,
    required this.cmsObject,
    required this.searchQuery,
    required this.page,
    required this.sortOptions,
  }) : super(key: key);

  @override
  State<CmsObjectOverview> createState() => _CmsObjectOverviewState();
}

class _CmsObjectOverviewState extends State<CmsObjectOverview> {
  final _overallPages = ValueNotifier(1);

  @override
  void dispose() {
    _overallPages.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CmsTopBar(
          title: widget.cmsObject.displayName,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                CmsObjectOverviewActions(
                  cmsObjectStructure: widget.cmsObject,
                  searchQuery: widget.searchQuery,
                  page: widget.page,
                  sortOptions: widget.sortOptions,
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: CmsObjectOverviewTable(
                    cmsObject: widget.cmsObject,
                    searchQuery: widget.searchQuery,
                    page: widget.page,
                    overallPages: _overallPages,
                    sortOptions: widget.sortOptions,
                  ),
                ),
                ValueListenableBuilder(
                  valueListenable: _overallPages,
                  builder: (BuildContext context, int value, Widget? child) {
                    return value > 1
                        ? Padding(
                            padding: const EdgeInsets.only(top: 16),
                            child: CmsObjectOverviewPagination(
                              cmsObject: widget.cmsObject,
                              page: widget.page,
                              overallPages: value,
                              searchQuery: widget.searchQuery,
                              sortOptions: widget.sortOptions,
                            ),
                          )
                        : const SizedBox.shrink();
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
