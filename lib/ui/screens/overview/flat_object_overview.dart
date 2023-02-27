import 'package:flutter/material.dart';
import 'package:flat/data_types/flat_object_sort_options.dart';
import 'package:flat/data_types/flat_object_structure.dart';
import 'package:flat/ui/screens/overview/widgets/flat_object_overview_actions.dart';
import 'package:flat/ui/screens/overview/widgets/flat_object_overview_pagination.dart';
import 'package:flat/ui/screens/overview/widgets/flat_object_overview_table.dart';
import 'package:flat/ui/widgets/flat_top_bar.dart';

class FlatObjectOverview extends StatefulWidget {
  final FlatObjectStructure flatObject;
  final String? searchQuery;
  final int page;
  final FlatObjectSortOptions? sortOptions;

  const FlatObjectOverview({
    Key? key,
    required this.flatObject,
    required this.searchQuery,
    required this.page,
    required this.sortOptions,
  }) : super(key: key);

  @override
  State<FlatObjectOverview> createState() => _FlatObjectOverviewState();
}

class _FlatObjectOverviewState extends State<FlatObjectOverview> {
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
        FlatTopBar(
          title: widget.flatObject.displayName,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                FlatObjectOverviewActions(
                  flatObjectStructure: widget.flatObject,
                  searchQuery: widget.searchQuery,
                  page: widget.page,
                  sortOptions: widget.sortOptions,
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: FlatObjectOverviewTable(
                    flatObject: widget.flatObject,
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
                            child: FlatObjectOverviewPagination(
                              flatObject: widget.flatObject,
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
