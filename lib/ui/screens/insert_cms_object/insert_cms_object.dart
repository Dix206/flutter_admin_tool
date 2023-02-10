import 'package:flutter/material.dart';
import 'package:flutter_cms/data_types/cms_object_sort_options.dart';
import 'package:flutter_cms/data_types/cms_object_structure.dart';
import 'package:flutter_cms/data_types/cms_object_value.dart';
import 'package:flutter_cms/routes.dart';
import 'package:flutter_cms/ui/flutter_cms_widget.dart';
import 'package:flutter_cms/ui/messages/error_message.dart';
import 'package:flutter_cms/ui/screens/insert_cms_object/insert_cms_object_view_model.dart';
import 'package:flutter_cms/ui/widgets/cms_button.dart';
import 'package:flutter_cms/ui/widgets/cms_error_widget.dart';
import 'package:flutter_cms/ui/widgets/cms_loading.dart';
import 'package:flutter_cms/ui/widgets/cms_top_bar.dart';
import 'package:go_router/go_router.dart';

class InsertCmsObject extends StatelessWidget {
  final String? existingCmsObjectValueId;
  final String cmsObjectId;
  final String? searchQuery;
  final int? page;
  final CmsObjectSortOptions? sortOptions;

  const InsertCmsObject({
    Key? key,
    this.existingCmsObjectValueId,
    required this.cmsObjectId,
    required this.searchQuery,
    required this.page,
    required this.sortOptions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cmsObject = FlutterCms.getObjectById(
      context: context,
      cmsObjectId: cmsObjectId,
    );

    if (cmsObject == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("There is no Object with the id $cmsObjectId"),
        ),
      );
    } else {
      return InsertCmsObjectViewModelProvider(
        cmsObject: cmsObject,
        existingCmsObjectValueId: existingCmsObjectValueId,
        onStateUpdate: (state) {
          if (state is InsertCmsObjectInitState && state.failure != null) {
            showErrorMessage(context: context, errorMessage: state.failure!);
          }

          if (state is InsertCmsObjectInitState && (state.isInsertSuccessfull || state.isDeletionSuccessfull)) {
            _onNavigateBack(
              context: context,
              cmsObject: cmsObject,
            );
          }
        },
        childBuilder: (context) {
          final state = InsertCmsObjectViewModel.of(context).state;

          if (state is InsertCmsObjectInitState) {
            return _Content(
              existingCmsObjectValueId: existingCmsObjectValueId,
              cmsObject: cmsObject,
              currentCmsObjectValue: state.currentCmsObjectValue,
              shouldDisplayValidationErrors: state.shouldDisplayValidationErrors,
              isInserting: state.isInserting,
              isDeleting: state.isDeleting,
              onNavigateBack: () => _onNavigateBack(
                context: context,
                cmsObject: cmsObject,
              ),
            );
          } else if (state is InsertCmsObjectLoadingState) {
            return const CmsLoading();
          } else if (state is InsertCmsObjectFailureState) {
            return CmsErrorWidget(
              errorMessage: state.failure,
              onRetry: InsertCmsObjectViewModel.of(context).init,
            );
          } else {
            return const SizedBox.shrink();
          }
        },
      );
    }
  }

  void _onNavigateBack({
    required BuildContext context,
    required CmsObjectStructure cmsObject,
  }) =>
      context.go(
        Routes.overview(
          cmsObjectId: cmsObject.id,
          page: page ?? 1,
          sortOptions: sortOptions,
          searchQuery: searchQuery,
        ),
      );
}

class _Content extends StatefulWidget {
  final String? existingCmsObjectValueId;
  final CmsObjectStructure cmsObject;
  final CmsObjectValue currentCmsObjectValue;
  final bool shouldDisplayValidationErrors;
  final bool isInserting;
  final bool isDeleting;
  final Function() onNavigateBack;

  const _Content({
    Key? key,
    required this.existingCmsObjectValueId,
    required this.cmsObject,
    required this.currentCmsObjectValue,
    required this.shouldDisplayValidationErrors,
    required this.isInserting,
    required this.isDeleting,
    required this.onNavigateBack,
  }) : super(key: key);

  @override
  State<_Content> createState() => _ContentState();
}

class _ContentState extends State<_Content> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _TopBar(
          existingCmsObjectValueId: widget.existingCmsObjectValueId,
          cmsObject: widget.cmsObject,
          isDeleting: widget.isDeleting,
          isInserting: widget.isInserting,
          onNavigateBack: widget.onNavigateBack,
        ),
        Expanded(
          child: _AttributeWidgets(
            cmsObject: widget.cmsObject,
            currentCmsObjectValue: widget.currentCmsObjectValue,
            shouldDisplayValidationErrors: widget.shouldDisplayValidationErrors,
          ),
        ),
      ],
    );
  }
}

class _TopBar extends StatelessWidget {
  final String? existingCmsObjectValueId;
  final bool isInserting;
  final bool isDeleting;
  final CmsObjectStructure cmsObject;
  final Function() onNavigateBack;

  const _TopBar({
    Key? key,
    required this.existingCmsObjectValueId,
    required this.isInserting,
    required this.isDeleting,
    required this.cmsObject,
    required this.onNavigateBack,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CmsTopBar(
      title: cmsObject.displayName,
      actions: [
        InkWell(
          onTap: onNavigateBack,
          child: Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: Theme.of(context).primaryColor,
            ),
            child: Icon(
              Icons.arrow_back,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
        ),
        CmsButton(
          onPressed: InsertCmsObjectViewModel.of(context).insertObject,
          text: "Speichern",
          isLoading: isInserting,
        ),
        if (cmsObject.onDeleteCmsObject != null && existingCmsObjectValueId != null)
          CmsButton(
            onPressed: () async {
              final shouldDeleteBject = await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text("Löschen"),
                  content: const Text("Möchten Sie das Objekt wirklich löschen?"),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text("Abbrechen"),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text("Löschen"),
                    ),
                  ],
                ),
              );

              if (shouldDeleteBject == true && context.mounted) {
                InsertCmsObjectViewModel.of(context).deleteObject();
              }
            },
            text: "Löschen",
            isLoading: isDeleting,
            buttonColor: Theme.of(context).colorScheme.error,
            textColor: Theme.of(context).colorScheme.onError,
          ),
      ],
    );
  }
}

class _AttributeWidgets extends StatelessWidget {
  final CmsObjectStructure cmsObject;
  final CmsObjectValue currentCmsObjectValue;
  final bool shouldDisplayValidationErrors;

  const _AttributeWidgets({
    Key? key,
    required this.cmsObject,
    required this.currentCmsObjectValue,
    required this.shouldDisplayValidationErrors,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: cmsObject.attributes.length,
      separatorBuilder: (context, index) => const SizedBox(height: 24),
      itemBuilder: (context, index) {
        final cmsValue = cmsObject.attributes[index];

        return Align(
          alignment: Alignment.centerLeft,
          child: cmsValue.buildWidget(
            context: context,
            currentValue: currentCmsObjectValue.getAttributValueByAttributId(cmsValue.id),
            shouldDisplayValidationErrors: shouldDisplayValidationErrors,
            onCmsTypeUpdated: (newValue) {
              InsertCmsObjectViewModel.of(context).updateAttributValue(
                id: cmsValue.id,
                value: newValue,
              );
            },
          ),
        );
      },
    );
  }
}
