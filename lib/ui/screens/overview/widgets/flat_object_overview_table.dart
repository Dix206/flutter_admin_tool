import 'package:flutter/material.dart';
import 'package:flutter_admin_tool/data_types/flat_object_sort_options.dart';
import 'package:flutter_admin_tool/data_types/flat_object_structure.dart';
import 'package:flutter_admin_tool/data_types/flat_object_value.dart';
import 'package:flutter_admin_tool/flat_app.dart';
import 'package:flutter_admin_tool/ui/routes.dart';
import 'package:flutter_admin_tool/ui/screens/overview/flat_object_overview_view_model.dart';
import 'package:flutter_admin_tool/ui/widgets/flat_error_widget.dart';
import 'package:flutter_admin_tool/ui/widgets/flat_loading.dart';
import 'package:go_router/go_router.dart';

const _tableEntryHeight = 56.0;
const _tableTitleEntryHeight = 40.0;
const _tableEntryWidth = 200.0;
const _idTableEntryWidth = 60.0;

class FlatObjectOverviewTable extends StatelessWidget {
  final FlatObjectStructure flatObject;
  final String? searchQuery;
  final int page;
  final ValueNotifier<int> overallPages;
  final FlatObjectSortOptions? sortOptions;

  const FlatObjectOverviewTable({
    Key? key,
    required this.flatObject,
    required this.searchQuery,
    required this.page,
    required this.overallPages,
    required this.sortOptions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final minWidth = flatObject.attributes
                .where(
                  (attribute) => attribute.shouldBeDisplayedOnOverviewTable,
                )
                .length *
            _tableEntryWidth +
        _idTableEntryWidth +
        32.0;

    return Card(
      margin: EdgeInsets.zero,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: SizedBox(
          width: double.infinity,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: minWidth > constraints.maxWidth
                      ? minWidth
                      : constraints.maxWidth,
                  child: Column(
                    children: [
                      _TableTitle(
                        flatObject: flatObject,
                        searchQuery: searchQuery,
                        page: page,
                        sortOptions: sortOptions,
                      ),
                      Expanded(
                        child: FlatObjectOverviewViewModelProvider(
                          flatObject: flatObject,
                          searchQuery: searchQuery,
                          page: page,
                          sortOptions: sortOptions,
                          onStateUpdate: (state) {
                            if (state.flatObjectValues != null) {
                              overallPages.value = state.totalPages;
                            }
                          },
                          childBuilder: (context) {
                            final state =
                                FlatObjectOverviewViewModel.of(context).state;

                            if (state.loadingError != null) {
                              return FlatErrorWidget(
                                errorMessage: state.loadingError!,
                                onRetry: FlatObjectOverviewViewModel.of(context)
                                    .init,
                              );
                            } else if (state.flatObjectValues == null) {
                              return const FlatLoading();
                            } else if (state.flatObjectValues!.isEmpty) {
                              return Center(
                                child: Text(
                                  FlatApp.getFlatTexts(context)
                                      .objectTableNoItemsMessage,
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                              );
                            } else {
                              return _TableContent(
                                flatObject: flatObject,
                                flatObjectValues: state.flatObjectValues!,
                                page: page,
                                overallPages: state.totalPages,
                                searchQuery: searchQuery,
                                sortOptions: sortOptions,
                                hasMoreItems: state.hasMoreItems,
                                isLoadingMoreItems: state.isLoadingMoreItems,
                                loadMoreItemsError: state.loadMoreItemsError,
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _TableTitle extends StatelessWidget {
  final FlatObjectStructure flatObject;
  final String? searchQuery;
  final int page;
  final FlatObjectSortOptions? sortOptions;

  const _TableTitle({
    Key? key,
    required this.flatObject,
    required this.searchQuery,
    required this.page,
    required this.sortOptions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: _tableTitleEntryHeight,
          width: double.infinity,
          color: Theme.of(context).colorScheme.primaryContainer,
        ),
        Row(
          children: [
            const SizedBox(width: 16),
            _TableEntry(
              text: FlatApp.getFlatTexts(context).objectTableIdTitle,
              textColor: Theme.of(context).colorScheme.onPrimaryContainer,
              width: _idTableEntryWidth,
              height: _tableTitleEntryHeight,
              canBeSorted: flatObject.canBeSortedById,
              isSortedAscending: sortOptions?.attributeId == "id"
                  ? sortOptions?.ascending == true
                  : null,
              onSort: (isSortedAscending) => context.go(
                Routes.overview(
                  flatObjectId: flatObject.id,
                  page: page,
                  searchQuery: searchQuery,
                  sortOptions: FlatObjectSortOptions(
                    attributeId: "id",
                    ascending: isSortedAscending,
                  ),
                ),
              ),
            ),
            ...flatObject.attributes
                .where(
                  (attribute) => attribute.shouldBeDisplayedOnOverviewTable,
                )
                .map(
                  (attribute) => _TableEntry(
                    text: attribute.displayName,
                    textColor: Theme.of(context).colorScheme.onPrimaryContainer,
                    height: _tableTitleEntryHeight,
                    canBeSorted: attribute.canObjectBeSortedByThisAttribute,
                    isSortedAscending: sortOptions?.attributeId == attribute.id
                        ? sortOptions?.ascending == true
                        : null,
                    onSort: (isSortedAscending) => context.go(
                      Routes.overview(
                        flatObjectId: flatObject.id,
                        page: page,
                        searchQuery: searchQuery,
                        sortOptions: FlatObjectSortOptions(
                          attributeId: attribute.id,
                          ascending: isSortedAscending,
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
            const SizedBox(width: 16),
          ],
        ),
      ],
    );
  }
}

class _TableContent extends StatefulWidget {
  final FlatObjectStructure flatObject;
  final List<FlatObjectValue> flatObjectValues;
  final int page;
  final int overallPages;
  final String? searchQuery;
  final FlatObjectSortOptions? sortOptions;
  final bool hasMoreItems;
  final bool isLoadingMoreItems;
  final String? loadMoreItemsError;

  const _TableContent({
    Key? key,
    required this.flatObject,
    required this.flatObjectValues,
    required this.page,
    required this.overallPages,
    required this.searchQuery,
    required this.sortOptions,
    required this.hasMoreItems,
    required this.isLoadingMoreItems,
    required this.loadMoreItemsError,
  }) : super(key: key);

  @override
  State<_TableContent> createState() => _TableContentState();
}

class _TableContentState extends State<_TableContent> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.offset + 50 >
              _scrollController.position.maxScrollExtent &&
          widget.loadMoreItemsError == null) {
        FlatObjectOverviewViewModel.of(context).loadMoreItems();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
      _scrollController.notifyListeners();
    });

    return ListView.separated(
      physics: const ClampingScrollPhysics(),
      controller: _scrollController,
      itemCount: widget.flatObjectValues.length +
          (widget.isLoadingMoreItems || widget.loadMoreItemsError != null
              ? 1
              : 0),
      separatorBuilder: (context, index) => const Divider(height: 0),
      itemBuilder: (context, index) {
        if (index == widget.flatObjectValues.length) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: widget.loadMoreItemsError != null
                ? FlatErrorWidget(
                    errorMessage: widget.loadMoreItemsError!,
                    onRetry:
                        FlatObjectOverviewViewModel.of(context).loadMoreItems,
                  )
                : const FlatLoading(),
          );
        }

        final flatObjectValue = widget.flatObjectValues[index];

        return InkWell(
          onTap: widget.flatObject.onUpdateFlatObject == null
              ? null
              : () => _updateObject(
                    context: context,
                    flatObjectValue: flatObjectValue,
                  ),
          child: Row(
            children: [
              const SizedBox(width: 16),
              _TableEntry(
                text: flatObjectValue.id ??
                    FlatApp.getFlatTexts(context).flatAttributeValueNull,
                width: _idTableEntryWidth,
              ),
              ...flatObjectValue.values
                  .where(
                    (flatAttributeValue) =>
                        widget.flatObject
                            .getAttributeById(flatAttributeValue.id)
                            ?.shouldBeDisplayedOnOverviewTable ??
                        false,
                  )
                  .map(
                    (flatAttributeValue) => _TableEntry(
                      text: widget.flatObject
                              .getAttributeById(flatAttributeValue.id)
                              ?.valueToString(
                                context: context,
                                value: flatAttributeValue.value,
                              ) ??
                          FlatApp.getFlatTexts(context).flatAttributeValueNull,
                    ),
                  )
                  .toList(),
              const SizedBox(width: 16),
            ],
          ),
        );
      },
    );
  }

  void _updateObject({
    required BuildContext context,
    required FlatObjectValue flatObjectValue,
  }) {
    context.go(
      Routes.updateObject(
        flatObjectId: widget.flatObject.id,
        existingFlatObjectValueId: flatObjectValue.id!,
        page: widget.page,
        searchQuery: widget.searchQuery,
        sortOptions: widget.sortOptions,
      ),
    );
  }
}

class _TableEntry extends StatelessWidget {
  final String text;
  final Color? textColor;
  final double height;
  final double width;
  final bool? isSortedAscending;
  final bool canBeSorted;
  final Function(bool isSortedAscending)? onSort;

  const _TableEntry({
    Key? key,
    required this.text,
    this.textColor,
    this.height = _tableEntryHeight,
    this.width = _tableEntryWidth,
    this.isSortedAscending = false,
    this.canBeSorted = false,
    this.onSort,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tableEntry = Tooltip(
      message: text,
      waitDuration: const Duration(seconds: 1),
      child: SizedBox(
        height: height,
        width: width,
        child: Row(
          children: [
            Expanded(
              child: Center(
                child: Text(text,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: textColor,
                        )),
              ),
            ),
            if (canBeSorted)
              Icon(
                isSortedAscending == null
                    ? Icons.unfold_more
                    : isSortedAscending!
                        ? Icons.arrow_drop_down
                        : Icons.arrow_drop_up,
                size: 16,
                color: textColor,
              ),
          ],
        ),
      ),
    );

    return canBeSorted
        ? InkWell(
            onTap: () => onSort?.call(!(isSortedAscending ?? false)),
            child: tableEntry,
          )
        : tableEntry;
  }
}
