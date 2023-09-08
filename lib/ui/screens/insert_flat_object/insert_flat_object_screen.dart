import 'package:flutter/material.dart';
import 'package:flutter_admin_tool/constants.dart';
import 'package:flutter_admin_tool/data_types/flat_object_sort_options.dart';
import 'package:flutter_admin_tool/data_types/flat_object_structure.dart';
import 'package:flutter_admin_tool/data_types/flat_object_value.dart';
import 'package:flutter_admin_tool/ui/routes.dart';
import 'package:flutter_admin_tool/flat_app.dart';
import 'package:flutter_admin_tool/ui/messages/error_message.dart';
import 'package:flutter_admin_tool/ui/screens/insert_flat_object/insert_flat_object_view_model.dart';
import 'package:flutter_admin_tool/ui/widgets/flat_button.dart';
import 'package:flutter_admin_tool/ui/widgets/flat_error_widget.dart';
import 'package:flutter_admin_tool/ui/widgets/flat_loading.dart';
import 'package:flutter_admin_tool/ui/widgets/flat_top_bar.dart';
import 'package:go_router/go_router.dart';

class InsertFlatObjectScreen extends StatelessWidget {
  final String? existingFlatObjectValueId;
  final String flatObjectId;
  final String? searchQuery;
  final int? page;
  final FlatObjectSortOptions? sortOptions;

  const InsertFlatObjectScreen({
    Key? key,
    this.existingFlatObjectValueId,
    required this.flatObjectId,
    required this.searchQuery,
    required this.page,
    required this.sortOptions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final flatObjectStructure = FlatApp.getFlatObjectStructureById(
      context: context,
      flatObjectId: flatObjectId,
    );

    if (flatObjectStructure == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            FlatApp.getFlatTexts(context).updateFlatObjectNoObjectFoundWithPassedId(flatObjectId),
            textAlign: TextAlign.center,
          ),
        ),
      );
    } else {
      return InsertFlatObjectViewModelProvider(
        flatObject: flatObjectStructure,
        existingFlatObjectValueId: existingFlatObjectValueId,
        onStateUpdate: (state) {
          if (state is InsertFlatObjectInitState && state.failure != null) {
            showErrorMessage(context: context, errorMessage: state.failure!);
          }

          if (state is InsertFlatObjectInitState && (state.isInsertSuccessfull || state.isDeletionSuccessfull)) {
            _onNavigateBack(
              context: context,
              flatObject: flatObjectStructure,
            );
          }
        },
        childBuilder: (context) {
          final state = InsertFlatObjectViewModel.of(context).state;

          if (state is InsertFlatObjectInitState) {
            return _Content(
              existingFlatObjectValueId: existingFlatObjectValueId,
              flatObject: flatObjectStructure,
              currentFlatObjectValue: state.currentFlatObjectValue,
              shouldDisplayValidationErrors: state.shouldDisplayValidationErrors,
              isInserting: state.isInserting,
              isDeleting: state.isDeleting,
              onNavigateBack: () => _onNavigateBack(
                context: context,
                flatObject: flatObjectStructure,
              ),
            );
          } else if (state is InsertFlatObjectLoadingState) {
            return const FlatLoading();
          } else if (state is InsertFlatObjectFailureState) {
            return FlatErrorWidget(
              errorMessage: state.failure,
              onRetry: InsertFlatObjectViewModel.of(context).init,
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
    required FlatObjectStructure flatObject,
  }) =>
      context.go(
        Routes.overview(
          flatObjectId: flatObject.id,
          page: page ?? 1,
          sortOptions: sortOptions,
          searchQuery: searchQuery,
        ),
      );
}

class _Content extends StatefulWidget {
  final String? existingFlatObjectValueId;
  final FlatObjectStructure flatObject;
  final FlatObjectValue currentFlatObjectValue;
  final bool shouldDisplayValidationErrors;
  final bool isInserting;
  final bool isDeleting;
  final Function() onNavigateBack;

  const _Content({
    Key? key,
    required this.existingFlatObjectValueId,
    required this.flatObject,
    required this.currentFlatObjectValue,
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _TopBar(
          existingFlatObjectValueId: widget.existingFlatObjectValueId,
          flatObject: widget.flatObject,
          isDeleting: widget.isDeleting,
          isInserting: widget.isInserting,
          onNavigateBack: widget.onNavigateBack,
        ),
        Expanded(
          child: _AttributeWidgets(
            existingFlatObjectValueId: widget.existingFlatObjectValueId,
            flatObject: widget.flatObject,
            currentFlatObjectValue: widget.currentFlatObjectValue,
            shouldDisplayValidationErrors: widget.shouldDisplayValidationErrors,
          ),
        ),
      ],
    );
  }
}

class _TopBar extends StatelessWidget {
  final String? existingFlatObjectValueId;
  final bool isInserting;
  final bool isDeleting;
  final FlatObjectStructure flatObject;
  final Function() onNavigateBack;

  const _TopBar({
    Key? key,
    required this.existingFlatObjectValueId,
    required this.isInserting,
    required this.isDeleting,
    required this.flatObject,
    required this.onNavigateBack,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width < mobileViewMaxWidth;

    return FlatTopBar(
      actions: [
        if (!isMobile)
          InkWell(
            onTap: onNavigateBack,
            child: Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Theme.of(context).colorScheme.primary,
              ),
              child: Icon(
                Icons.arrow_back,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ),
        FlatButton(
          onPressed: () => InsertFlatObjectViewModel.of(context).insertObject(context),
          text: FlatApp.getFlatTexts(context).save,
          isLoading: isInserting,
        ),
        if (flatObject.onDeleteFlatObject != null && existingFlatObjectValueId != null)
          FlatButton(
            onPressed: () async {
              final shouldDeleteBject = await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(FlatApp.getFlatTexts(context).delete),
                  content: Text(
                    FlatApp.getFlatTexts(context).deleteFlatObjectValueConfirmationMessage,
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: Text(FlatApp.getFlatTexts(context).cancel),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: Text(FlatApp.getFlatTexts(context).delete),
                    ),
                  ],
                ),
              );

              if (shouldDeleteBject == true && context.mounted) {
                InsertFlatObjectViewModel.of(context).deleteObject();
              }
            },
            text: FlatApp.getFlatTexts(context).delete,
            isLoading: isDeleting,
            buttonColor: Theme.of(context).colorScheme.error,
            textColor: Theme.of(context).colorScheme.onError,
          ),
      ],
    );
  }
}

class _AttributeWidgets extends StatelessWidget {
  final String? existingFlatObjectValueId;
  final FlatObjectStructure flatObject;
  final FlatObjectValue currentFlatObjectValue;
  final bool shouldDisplayValidationErrors;

  const _AttributeWidgets({
    Key? key,
    required this.existingFlatObjectValueId,
    required this.flatObject,
    required this.currentFlatObjectValue,
    required this.shouldDisplayValidationErrors,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: flatObject.attributes.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final flatValue = flatObject.attributes[index];

        return Align(
          alignment: Alignment.centerLeft,
          child: Card(
            child: SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${flatValue.displayName}${flatValue.isOptional ? "" : " *"}",
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 16),
                    flatValue.canBeEdited || existingFlatObjectValueId == null
                        ? flatValue.buildWidget(
                            currentValue: currentFlatObjectValue.getAttributeValueByAttributeId(flatValue.id),
                            shouldDisplayValidationErrors: shouldDisplayValidationErrors,
                            onFlatTypeUpdated: (newValue) {
                              InsertFlatObjectViewModel.of(context).updateAttributeValue(
                                id: flatValue.id,
                                value: newValue,
                              );
                            },
                          )
                        : SelectableText(
                            flatValue.valueToString(
                                context: context,
                                value: currentFlatObjectValue.getAttributeValueByAttributeId(flatValue.id)),
                          ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
