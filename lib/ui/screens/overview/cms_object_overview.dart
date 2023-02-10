import 'package:flutter/material.dart';
import 'package:flutter_cms/data_types/cms_object_structure.dart';
import 'package:flutter_cms/ui/screens/overview/cms_object_overview_view_model.dart';
import 'package:flutter_cms/ui/screens/overview/widgets/cms_object_overview_actions.dart';
import 'package:flutter_cms/ui/screens/overview/widgets/cms_object_overview_pagination.dart';
import 'package:flutter_cms/ui/screens/overview/widgets/cms_object_overview_table.dart';
import 'package:flutter_cms/ui/widgets/cms_error_widget.dart';
import 'package:flutter_cms/ui/widgets/cms_loading.dart';
import 'package:flutter_cms/ui/widgets/cms_top_bar.dart';

class CmsObjectOverview extends StatefulWidget {
  final CmsObjectStructure cmsObject;
  final String? searchQuery;
  final int page;

  const CmsObjectOverview({
    Key? key,
    required this.cmsObject,
    required this.searchQuery,
    required this.page,
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
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: _TableContent(
                    cmsObject: widget.cmsObject,
                    searchQuery: widget.searchQuery,
                    page: widget.page,
                    overallPages: _overallPages,
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

class _TableContent extends StatelessWidget {
  final CmsObjectStructure cmsObject;
  final String? searchQuery;
  final int page;
  final ValueNotifier<int> overallPages;

  const _TableContent({
    Key? key,
    required this.cmsObject,
    required this.searchQuery,
    required this.page,
    required this.overallPages,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CmsObjectOverviewViewModelProvider(
      cmsObject: cmsObject,
      searchQuery: searchQuery,
      page: page,
      onStateUpdate: (state) {
        if (state.cmsObjectValues != null) overallPages.value = state.totalPages;
      },
      childBuilder: (context) {
        final state = CmsObjectOverviewViewModel.of(context).state;

        final Widget content;

        if (state.loadingError != null) {
          content = CmsErrorWidget(
            errorMessage: state.loadingError!,
            onRetry: CmsObjectOverviewViewModel.of(context).init,
          );
        } else if (state.cmsObjectValues == null) {
          content = const CmsLoading();
        } else {
          content = CmsObjectOverviewTable(
            cmsObject: cmsObject,
            cmsObjectValues: state.cmsObjectValues!,
            page: page,
            overallPages: state.totalPages,
            searchQuery: searchQuery,
          );
        }

        return Card(
          margin: EdgeInsets.zero,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: SizedBox(
              width: double.infinity,
              child: content,
            ),
          ),
        );
      },
    );
  }
}
