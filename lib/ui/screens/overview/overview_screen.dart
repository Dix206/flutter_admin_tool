import 'package:flutter/material.dart';
import 'package:flat/data_types/flat_object_sort_options.dart';
import 'package:flat/ui/screens/overview/flat_object_overview.dart';
import 'package:flat/flat_app.dart';

class OverviewScreen extends StatelessWidget {
  final String selectedFlatObjectId;
  final String? searchQuery;
  final int page;
  final FlatObjectSortOptions? sortOptions;

  const OverviewScreen({
    Key? key,
    required this.selectedFlatObjectId,
    required this.searchQuery,
    required this.page,
    required this.sortOptions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final selectedFlatObjectStructure = FlatApp.getFlatObjectStructureById(
      context: context,
      flatObjectId: selectedFlatObjectId,
    );

    return selectedFlatObjectStructure == null
        ? Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                FlatApp.getFlatTexts(context).noFlatObjectStructureObjectFoundWithPassedId(selectedFlatObjectId),
                textAlign: TextAlign.center,
              ),
            ),
          )
        : FlatObjectOverview(
            flatObject: selectedFlatObjectStructure,
            searchQuery: searchQuery,
            page: page,
            sortOptions: sortOptions,
          );
  }
}
