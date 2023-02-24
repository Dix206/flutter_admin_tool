import 'package:flutter/material.dart';
import 'package:flutter_cms/data_types/cms_object_sort_options.dart';
import 'package:flutter_cms/data_types/cms_object_structure.dart';
import 'package:flutter_cms/data_types/cms_object_value.dart';
import 'package:flutter_cms/flutter_cms.dart';
import 'package:flutter_cms/ui/routes.dart';
import 'package:flutter_cms/ui/screens/overview/cms_object_overview_view_model.dart';
import 'package:flutter_cms/ui/widgets/cms_error_widget.dart';
import 'package:flutter_cms/ui/widgets/cms_loading.dart';
import 'package:go_router/go_router.dart';

const _tableEntryHeight = 56.0;
const _tableTitleEntryHeight = 40.0;
const _tableEntryWidth = 200.0;
const _idTableEntryWidth = 60.0;

class CmsObjectOverviewTable extends StatelessWidget {
  final CmsObjectStructure cmsObject;
  final String? searchQuery;
  final int page;
  final ValueNotifier<int> overallPages;
  final CmsObjectSortOptions? sortOptions;

  const CmsObjectOverviewTable({
    Key? key,
    required this.cmsObject,
    required this.searchQuery,
    required this.page,
    required this.overallPages,
    required this.sortOptions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final minWidth = cmsObject.attributes
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
                  width: minWidth > constraints.maxWidth ? minWidth : constraints.maxWidth,
                  child: Column(
                    children: [
                      _TableTitle(
                        cmsObject: cmsObject,
                        searchQuery: searchQuery,
                        page: page,
                        sortOptions: sortOptions,
                      ),
                      Expanded(
                        child: CmsObjectOverviewViewModelProvider(
                          cmsObject: cmsObject,
                          searchQuery: searchQuery,
                          page: page,
                          sortOptions: sortOptions,
                          onStateUpdate: (state) {
                            if (state.cmsObjectValues != null) overallPages.value = state.totalPages;
                          },
                          childBuilder: (context) {
                            final state = CmsObjectOverviewViewModel.of(context).state;

                            if (state.loadingError != null) {
                              return CmsErrorWidget(
                                errorMessage: state.loadingError!,
                                onRetry: CmsObjectOverviewViewModel.of(context).init,
                              );
                            } else if (state.cmsObjectValues == null) {
                              return const CmsLoading();
                            } else if (state.cmsObjectValues!.isEmpty) {
                              return Center(
                                child: Text(
                                  FlutterCms.getCmsTexts(context).objectTableNoItemsMessage,
                                  style: Theme.of(context).textTheme.titleMedium,
                                ),
                              );
                            } else {
                              return _TableContent(
                                cmsObject: cmsObject,
                                cmsObjectValues: state.cmsObjectValues!,
                                page: page,
                                overallPages: state.totalPages,
                                searchQuery: searchQuery,
                                sortOptions: sortOptions,
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
  final CmsObjectStructure cmsObject;
  final String? searchQuery;
  final int page;
  final CmsObjectSortOptions? sortOptions;

  const _TableTitle({
    Key? key,
    required this.cmsObject,
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
              text: FlutterCms.getCmsTexts(context).objectTableIdTitle,
              textColor: Theme.of(context).colorScheme.onPrimaryContainer,
              width: _idTableEntryWidth,
              height: _tableTitleEntryHeight,
              canBeSorted: cmsObject.canBeSortedById,
              isSortedAscending: sortOptions?.attributeId == "id" ? sortOptions?.ascending == true : null,
              onSort: (isSortedAscending) => context.go(
                Routes.overview(
                  cmsObjectId: cmsObject.id,
                  page: page,
                  searchQuery: searchQuery,
                  sortOptions: CmsObjectSortOptions(
                    attributeId: "id",
                    ascending: isSortedAscending,
                  ),
                ),
              ),
            ),
            ...cmsObject.attributes
                .where(
                  (attribute) => attribute.shouldBeDisplayedOnOverviewTable,
                )
                .map(
                  (attribute) => _TableEntry(
                    text: attribute.displayName,
                    textColor: Theme.of(context).colorScheme.onPrimaryContainer,
                    height: _tableTitleEntryHeight,
                    canBeSorted: attribute.canObjectBeSortedByThisAttribute,
                    isSortedAscending: sortOptions?.attributeId == attribute.id ? sortOptions?.ascending == true : null,
                    onSort: (isSortedAscending) => context.go(
                      Routes.overview(
                        cmsObjectId: cmsObject.id,
                        page: page,
                        searchQuery: searchQuery,
                        sortOptions: CmsObjectSortOptions(
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

class _TableContent extends StatelessWidget {
  final CmsObjectStructure cmsObject;
  final List<CmsObjectValue> cmsObjectValues;
  final int page;
  final int overallPages;
  final String? searchQuery;
  final CmsObjectSortOptions? sortOptions;

  const _TableContent({
    Key? key,
    required this.cmsObject,
    required this.cmsObjectValues,
    required this.page,
    required this.overallPages,
    required this.searchQuery,
    required this.sortOptions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const ClampingScrollPhysics(),
      itemCount: cmsObjectValues.length,
      separatorBuilder: (context, index) => const Divider(height: 0),
      itemBuilder: (context, index) {
        final cmsObjectValue = cmsObjectValues[index];

        return InkWell(
          onTap: cmsObject.onUpdateCmsObject == null
              ? null
              : () => _updateObject(
                    context: context,
                    cmsObjectValue: cmsObjectValue,
                  ),
          child: Row(
            children: [
              const SizedBox(width: 16),
              _TableEntry(
                text: cmsObjectValue.id ?? FlutterCms.getCmsTexts(context).cmsAttributeValueNull,
                width: _idTableEntryWidth,
              ),
              ...cmsObjectValue.values
                  .where(
                    (cmsAttributeValue) =>
                        cmsObject.getAttributeById(cmsAttributeValue.id)?.shouldBeDisplayedOnOverviewTable ?? false,
                  )
                  .map(
                    (cmsAttributeValue) => _TableEntry(
                      text: cmsObject.getAttributeById(cmsAttributeValue.id)?.valueToString(
                                context: context,
                                value: cmsAttributeValue.value,
                              ) ??
                          FlutterCms.getCmsTexts(context).cmsAttributeValueNull,
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
    required CmsObjectValue cmsObjectValue,
  }) {
    context.go(
      Routes.updateObject(
        cmsObjectId: cmsObject.id,
        existingCmsObjectValueId: cmsObjectValue.id!,
        page: page,
        searchQuery: searchQuery,
        sortOptions: sortOptions,
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
