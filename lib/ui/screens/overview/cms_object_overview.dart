import 'package:flutter/material.dart';
import 'package:flutter_cms/data_types/cms_object_structure.dart';
import 'package:flutter_cms/data_types/cms_object_value.dart';
import 'package:flutter_cms/routes.dart';
import 'package:flutter_cms/ui/messages/error_message.dart';
import 'package:flutter_cms/ui/screens/overview/cms_object_overview_view_model.dart';
import 'package:flutter_cms/ui/widgets/cms_button.dart';
import 'package:flutter_cms/ui/widgets/cms_error_widget.dart';
import 'package:flutter_cms/ui/widgets/cms_loading.dart';
import 'package:flutter_cms/ui/widgets/cms_top_bar.dart';
import 'package:go_router/go_router.dart';

class CmsObjectOverview extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Column(
      children: [
        CmsTopBar(
          title: cmsObject.displayName,
          actions: [
            CmsButton(
              text: "Neues Objekt",
              onPressed: () => context.go(Routes.createObject(cmsObject.id)),
            ),
            _SearchBar(
              cmsObject: cmsObject,
            ),
          ],
        ),
        const SizedBox(height: 16),
        Expanded(
          child: CmsObjectOverviewViewModelProvider(
            cmsObject: cmsObject,
            searchQuery: searchQuery,
            page: page,
            childBuilder: (context) {
              final state = CmsObjectOverviewViewModel.of(context).state;

              if (state.loadingError != null) {
                return CmsErrorWidget(
                  errorMessage: state.loadingError!,
                  onRetry: CmsObjectOverviewViewModel.of(context).init,
                );
              } else if (state.cmsObjectValues == null) {
                return const CmsLoading();
              } else {
                return _CmsObjectContent(
                  cmsObject: cmsObject,
                  cmsObjectValues: state.cmsObjectValues!,
                  page: page,
                  overallPages: state.totalPages,
                  searchQuery: searchQuery,
                );
              }
            },
          ),
        ),
      ],
    );
  }
}

class _CmsObjectContent extends StatelessWidget {
  final CmsObjectStructure cmsObject;
  final List<CmsObjectValue> cmsObjectValues;
  final int page;
  final int overallPages;
  final String? searchQuery;

  const _CmsObjectContent({
    Key? key,
    required this.cmsObject,
    required this.cmsObjectValues,
    required this.page,
    required this.overallPages,
    required this.searchQuery,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: (cmsObject.attributes
                              .where(
                                (attribut) => attribut.shouldBeDisplayedOnOverviewTable,
                              )
                              .length +
                          1) *
                      160 +
                  32,
              child: Column(
                children: [
                  Row(
                    children: [
                      const SizedBox(width: 16),
                      const _TableEntry(
                        text: "ID",
                        isTitle: true,
                      ),
                      ...cmsObject.attributes
                          .where(
                            (attribut) => attribut.shouldBeDisplayedOnOverviewTable,
                          )
                          .map(
                            (attribute) => _TableEntry(
                              text: attribute.displayName,
                              isTitle: true,
                            ),
                          )
                          .toList(),
                      const SizedBox(width: 16),
                    ],
                  ),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.only(
                        bottom: 16,
                        left: 16,
                        right: 16,
                      ),
                      physics: const ClampingScrollPhysics(),
                      itemCount: cmsObjectValues.length,
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
                              _TableEntry(
                                text: cmsObjectValue.id ?? "---",
                              ),
                              ...cmsObjectValue.values
                                  .where(
                                    (cmsAttributeValue) =>
                                        cmsObject
                                            .getAttributById(cmsAttributeValue.id)
                                            ?.shouldBeDisplayedOnOverviewTable ??
                                        false,
                                  )
                                  .map(
                                    (cmsAttributeValue) => _TableEntry(
                                      text: cmsObject
                                              .getAttributById(cmsAttributeValue.id)
                                              ?.valueToString(cmsAttributeValue.value) ??
                                          "---",
                                    ),
                                  )
                                  .toList(),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (overallPages > 1)
          _Pagination(
            cmsObject: cmsObject,
            page: page,
            overallPages: overallPages,
            searchQuery: searchQuery,
          ),
      ],
    );
  }

  void _updateObject({
    required BuildContext context,
    required CmsObjectValue cmsObjectValue,
  }) {
    if (cmsObjectValue.id == null) {
      showErrorMessage(
        context: context,
        errorMessage: "Das Objekt kann nicht bearbeitet werden, da es keine ID hat.",
      );
      return;
    }

    context.go(
      Routes.updateObject(
        cmsObjectId: cmsObject.id,
        existingCmsObjectValueId: cmsObjectValue.id!,
      ),
    );
  }
}

class _TableEntry extends StatelessWidget {
  final bool isTitle;
  final String text;

  const _TableEntry({
    Key? key,
    this.isTitle = false,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      width: 160,
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).colorScheme.onSurface,
          width: 1,
        ),
      ),
      child: Center(
        child: Text(
          text,
          style: isTitle ? Theme.of(context).textTheme.titleSmall : Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }
}

class _Pagination extends StatelessWidget {
  final CmsObjectStructure cmsObject;
  final int page;
  final int overallPages;
  final String? searchQuery;

  const _Pagination({
    Key? key,
    required this.cmsObject,
    required this.page,
    required this.overallPages,
    required this.searchQuery,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4.0,
            offset: Offset(0.0, -0.75),
          ),
        ],
        color: Theme.of(context).colorScheme.surface,
      ),
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          overallPages,
          (index) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: CmsButton(
              text: (index + 1).toString(),
              onPressed: (index + 1) == page ? null : () => context.go(
                Routes.overview(
                  cmsObjectId: cmsObject.id,
                  page: index + 1,
                  searchQuery: searchQuery,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SearchBar extends StatefulWidget {
  final CmsObjectStructure cmsObject;

  const _SearchBar({
    Key? key,
    required this.cmsObject,
  }) : super(key: key);

  @override
  State<_SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<_SearchBar> {
  final _textEditingController = TextEditingController();

  @override
  void initState() {
    // _textEditingController.addListener(() {
    //   CmsObjectOverviewViewModel.of(context).setSearchString(_textEditingController.text);
    // });
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 200,
          child: TextField(
            controller: _textEditingController,
          ),
        ),
        const SizedBox(width: 8),
        CmsButton(
          text: "Suchen",
          onPressed: () => context.go(
            Routes.overview(
              cmsObjectId: widget.cmsObject.id,
              page: 1,
              searchQuery: _textEditingController.text.trim().isEmpty ? null : _textEditingController.text.trim(),
            ),
          ),
        ),
      ],
    );
  }
}
