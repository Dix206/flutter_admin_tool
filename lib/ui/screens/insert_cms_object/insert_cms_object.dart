import 'package:flutter/material.dart';
import 'package:flutter_cms/data_types/cms_object.dart';
import 'package:flutter_cms/data_types/cms_object_value.dart';
import 'package:flutter_cms/ui/flutter_cms_widget.dart';
import 'package:flutter_cms/ui/messages/error_message.dart';
import 'package:flutter_cms/ui/screens/insert_cms_object/insert_cms_object_view_model.dart';
import 'package:flutter_cms/ui/widgets/cms_error_widget.dart';
import 'package:flutter_cms/ui/widgets/cms_loading.dart';

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

    final Widget content;

    if (cmsObject == null) {
      content = Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("There is no Object with the name $cmsObjectName"),
        ),
      );
    } else {
      content = InsertCmsObjectViewModelProvider(
        cmsObject: cmsObject,
        existingCmsObjectValueId: existingCmsObjectValueId,
        onStateUpdate: (state) {
          if (state is InsertCmsObjectInitState && state.failure != null) {
            showErrorMessage(context: context, errorMessage: state.failure!);
          }

          if (state is InsertCmsObjectInitState && state.isInsertSuccessfull) {
            Navigator.pop(context);
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

    return Scaffold(
      body: content,
    );
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
        Expanded(
          child: _AttributeWidgets(
            cmsObject: widget.cmsObject,
            currentCmsObjectValue: widget.currentCmsObjectValue,
            shouldDisplayValidationErrors: widget.shouldDisplayValidationErrors,
          ),
        ),
        _InsertButton(
          cmsObject: widget.cmsObject,
          isLoading: widget.isLoading,
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
      itemCount: cmsObject.attributes.length,
      separatorBuilder: (context, index) => const SizedBox(height: 24),
      itemBuilder: (context, index) {
        final cmsValue = cmsObject.attributes[index];

        return cmsValue.buildWidget(
          context: context,
          currentValue: currentCmsObjectValue.getAttributeValueByName(cmsValue.name)?.value,
          shouldDisplayValidationErrors: shouldDisplayValidationErrors,
          onCmsTypeUpdated: (newValue) {
            InsertCmsObjectViewModel.of(context).updateAttributValue(
              name: cmsValue.name,
              value: newValue,
            );
          },
        );
      },
    );
  }
}

class _InsertButton extends StatefulWidget {
  final CmsObject cmsObject;
  final bool isLoading;

  const _InsertButton({
    Key? key,
    required this.cmsObject,
    required this.isLoading,
  }) : super(key: key);

  @override
  __InsertButtonState createState() => __InsertButtonState();
}

class __InsertButtonState extends State<_InsertButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: InsertCmsObjectViewModel.of(context).insertObject,
      child: widget.isLoading ? const CircularProgressIndicator() : const Text("Speichern"),
    );
  }
}
