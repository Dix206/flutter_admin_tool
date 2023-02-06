import 'package:flutter/material.dart';
import 'package:flutter_cms/data_types/cms_object.dart';
import 'package:flutter_cms/data_types/cms_object_value.dart';
import 'package:flutter_cms/routes.dart';
import 'package:flutter_cms/ui/messages/error_message.dart';
import 'package:flutter_cms/ui/screens/overview/cms_object_overview_view_model.dart';
import 'package:flutter_cms/ui/widgets/cms_error_widget.dart';
import 'package:flutter_cms/ui/widgets/cms_loading.dart';
import 'package:go_router/go_router.dart';

class CmsObjectOverview extends StatelessWidget {
  final CmsObject cmsObject;

  const CmsObjectOverview({
    Key? key,
    required this.cmsObject,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CmsObjectOverviewViewModelProvider(
      cmsObject: cmsObject,
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
            hasMoreItems: state.hasMoreItems,
            isLoadingMoreItems: state.isLoadingMoreItems,
            loadMoreItemsError: state.loadMoreItemsError,
          );
        }
      },
    );
  }
}

class _CmsObjectContent extends StatefulWidget {
  final CmsObject cmsObject;
  final List<CmsObjectValue> cmsObjectValues;
  final bool hasMoreItems;
  final bool isLoadingMoreItems;
  final String? loadMoreItemsError;

  const _CmsObjectContent({
    Key? key,
    required this.cmsObject,
    required this.cmsObjectValues,
    required this.hasMoreItems,
    required this.isLoadingMoreItems,
    required this.loadMoreItemsError,
  }) : super(key: key);

  @override
  State<_CmsObjectContent> createState() => _CmsObjectContentState();
}

class _CmsObjectContentState extends State<_CmsObjectContent> {
  late final scrollController = ScrollController();

  @override
  void initState() {
    scrollController.addListener(() {
      if (scrollController.offset > scrollController.position.maxScrollExtent - 100) {
        CmsObjectOverviewViewModel.of(context).loadMoreItems();
      }
    });
    Future.delayed(
      const Duration(milliseconds: 500),
      // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
      () => scrollController.notifyListeners(),
    );
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () => context.go(Routes.createObject(widget.cmsObject.name)),
          child: const Text("Neues Objekt"),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: (widget.cmsObject.attributes
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
                      ...widget.cmsObject.attributes
                          .where(
                            (attribut) => attribut.shouldBeDisplayedOnOverviewTable,
                          )
                          .map(
                            (attribute) => _TableEntry(
                              text: attribute.name,
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
                      controller: scrollController,
                      physics: const ClampingScrollPhysics(),
                      itemCount: widget.cmsObjectValues.length + (widget.hasMoreItems ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (widget.hasMoreItems && index == widget.cmsObjectValues.length) {
                          if (widget.loadMoreItemsError != null) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: CmsErrorWidget(
                                errorMessage: widget.loadMoreItemsError!,
                                onRetry: CmsObjectOverviewViewModel.of(context).loadMoreItems,
                              ),
                            );
                          } else if (widget.isLoadingMoreItems) {
                            return const Padding(
                              padding: EdgeInsets.only(top: 8),
                              child: CmsLoading(size: 16),
                            );
                          } else {
                            return const SizedBox.shrink();
                          }
                        }

                        final cmsObjectValue = widget.cmsObjectValues[index];

                        return InkWell(
                          onTap: widget.cmsObject.onUpdateCmsObject == null
                              ? null
                              : () => _updateObject(
                                    context: context,
                                    cmsObjectValue: cmsObjectValue,
                                  ),
                          child: Row(
                            children: [
                              _TableEntry(
                                text:
                                    cmsObjectValue.id == null ? "---" : widget.cmsObject.idToString(cmsObjectValue.id!),
                              ),
                              ...cmsObjectValue.values
                                  .where(
                                    (cmsAttributeValue) =>
                                        widget.cmsObject
                                            .getAttributByName(cmsAttributeValue.name)
                                            ?.shouldBeDisplayedOnOverviewTable ??
                                        false,
                                  )
                                  .map(
                                    (cmsAttributeValue) => _TableEntry(
                                      text: widget.cmsObject
                                              .getAttributByName(cmsAttributeValue.name)
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
        cmsObjectName: widget.cmsObject.name,
        existingCmsObjectValueId: widget.cmsObject.idToString(cmsObjectValue.id!),
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
