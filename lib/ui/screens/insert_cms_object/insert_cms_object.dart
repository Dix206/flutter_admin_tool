import 'package:flutter/material.dart';
import 'package:flutter_cms/data_types/cms_object.dart';
import 'package:flutter_cms/data_types/cms_object_value.dart';
import 'package:flutter_cms/routes.dart';
import 'package:flutter_cms/ui/flutter_cms_widget.dart';
import 'package:flutter_cms/ui/messages/error_message.dart';
import 'package:flutter_cms/ui/screens/insert_cms_object/insert_cms_object_view_model.dart';
import 'package:flutter_cms/ui/widgets/cms_error_widget.dart';
import 'package:flutter_cms/ui/widgets/cms_loading.dart';
import 'package:go_router/go_router.dart';

class InsertCmsObject extends StatelessWidget {
  final String? existingCmsObjectValueId;
  final String cmsObjectName;

  const InsertCmsObject({
    Key? key,
    this.existingCmsObjectValueId,
    required this.cmsObjectName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cmsObject = FlutterCms.getObjectByName(
      context: context,
      cmsObjectName: cmsObjectName,
    );

    if (cmsObject == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("There is no Object with the name $cmsObjectName"),
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

          if (state is InsertCmsObjectInitState && state.isInsertSuccessfull) {
            context.go(Routes.overview(cmsObject.name));
          }
        },
        childBuilder: (context) {
          final state = InsertCmsObjectViewModel.of(context).state;

          if (state is InsertCmsObjectInitState) {
            return _Content(
              cmsObject: cmsObject,
              currentCmsObjectValue: state.currentCmsObjectValue,
              shouldDisplayValidationErrors: state.shouldDisplayValidationErrors,
              isLoading: state.isInserting,
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
}

class _Content extends StatefulWidget {
  final CmsObject cmsObject;
  final CmsObjectValue currentCmsObjectValue;
  final bool shouldDisplayValidationErrors;
  final bool isLoading;

  const _Content({
    Key? key,
    required this.cmsObject,
    required this.currentCmsObjectValue,
    required this.shouldDisplayValidationErrors,
    required this.isLoading,
  }) : super(key: key);

  @override
  State<_Content> createState() => _ContentState();
}

class _ContentState extends State<_Content> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            boxShadow: const <BoxShadow>[
              BoxShadow(
                color: Colors.black26,
                blurRadius: 4.0,
                offset: Offset(0.0, 0.75),
              ),
            ],
            color: Theme.of(context).colorScheme.surface,
          ),
          height: 56,
          child: Row(
            children: [
              const SizedBox(width: 8),
              InkWell(
                onTap: () => context.go(Routes.overview(widget.cmsObject.name)),
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
              const SizedBox(width: 16),
              InkWell(
                onTap: widget.isLoading ? null : InsertCmsObjectViewModel.of(context).insertObject,
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: widget.isLoading ? Colors.grey : Theme.of(context).primaryColor,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Center(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Text(
                            "Speichern",
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: widget.isLoading ? Colors.grey : Theme.of(context).colorScheme.onPrimary,
                                ),
                          ),
                          SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              color: widget.isLoading ? Colors.black : Colors.transparent,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    widget.cmsObject.name,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ),
              ),
            ],
          ),
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

class _AttributeWidgets extends StatelessWidget {
  final CmsObject cmsObject;
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
            currentValue: currentCmsObjectValue.getAttributeValueByName(cmsValue.name)?.value,
            shouldDisplayValidationErrors: shouldDisplayValidationErrors,
            onCmsTypeUpdated: (newValue) {
              InsertCmsObjectViewModel.of(context).updateAttributValue(
                name: cmsValue.name,
                value: newValue,
              );
            },
          ),
        );
      },
    );
  }
}
