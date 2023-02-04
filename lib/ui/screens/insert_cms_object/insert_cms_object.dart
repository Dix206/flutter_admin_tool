import 'package:flutter/material.dart';
import 'package:flutter_cms/data_types/cms_attribut_value.dart';
import 'package:flutter_cms/data_types/cms_object.dart';
import 'package:flutter_cms/data_types/cms_object_value.dart';
import 'package:flutter_cms/data_types/result.dart';
import 'package:flutter_cms/ui/flutter_cms_widget.dart';
import 'package:flutter_cms/ui/messages/error_message.dart';
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
    } else if (existingCmsObjectValueId == null) {
      content = _Content(
        cmsObject: cmsObject,
        existingCmsObjectValue: null,
      );
    } else {
      content = FutureBuilder(
        future: cmsObject.loadCmsObjectById(
          cmsObject.stringToId(existingCmsObjectValueId!)!,
        ),
        builder: (context, snapshot) {
          if (snapshot.data == null) return const CmsLoading();

          return snapshot.data!.fold(
            onError: (errorMessage) => CmsErrorWidget(
              errorMessage: errorMessage,
              onRetry: () {}, // TODO how to recall future builder
            ),
            onSuccess: (cmsObjectValue) => _Content(
              cmsObject: cmsObject,
              existingCmsObjectValue: cmsObjectValue,
            ),
          );
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
  final CmsObjectValue? existingCmsObjectValue;

  const _Content({
    Key? key,
    required this.cmsObject,
    required this.existingCmsObjectValue,
  }) : super(key: key);

  @override
  State<_Content> createState() => _ContentState();
}

class _ContentState extends State<_Content> {
  final _shouldDisplayValidationErrors = ValueNotifier(false);
  late final _currentCmsObjectValue = ValueNotifier(
    widget.cmsObject.toEmptyCmsObjectValue(),
  );

  @override
  void dispose() {
    _shouldDisplayValidationErrors.dispose();
    _currentCmsObjectValue.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: _currentCmsObjectValue,
        builder: (context, currentCmsObjectValue, child) {
          return ValueListenableBuilder(
              valueListenable: _shouldDisplayValidationErrors,
              builder: (context, shouldDisplayValidationErrors, child) {
                return Column(
                  children: [
                    Expanded(
                      child: _AttributeWidgets(
                        cmsObject: widget.cmsObject,
                        currentCmsObjectValue: _currentCmsObjectValue,
                        shouldDisplayValidationErrors:
                            shouldDisplayValidationErrors,
                        existingCmsObjectValue: widget.existingCmsObjectValue,
                      ),
                    ),
                    _InsertButton(
                      currentCmsObjectValue: _currentCmsObjectValue.value,
                      cmsObject: widget.cmsObject,
                      existingCmsObjectValue: widget.existingCmsObjectValue,
                      shouldDisplayValidationErrors:
                          _shouldDisplayValidationErrors,
                    ),
                  ],
                );
              });
        });
  }
}

class _AttributeWidgets extends StatelessWidget {
  final CmsObject cmsObject;
  final CmsObjectValue? existingCmsObjectValue;
  final ValueNotifier<CmsObjectValue> currentCmsObjectValue;
  final bool shouldDisplayValidationErrors;

  const _AttributeWidgets({
    Key? key,
    required this.cmsObject,
    required this.currentCmsObjectValue,
    required this.shouldDisplayValidationErrors,
    this.existingCmsObjectValue,
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
          currentValue: currentCmsObjectValue.value
                  .getAttributeValueByName(cmsValue.name)
                  ?.value ??
              existingCmsObjectValue?.values[index].value,
          shouldDisplayValidationErrors: shouldDisplayValidationErrors,
          onCmsTypeUpdated: (newValue) {
            currentCmsObjectValue.value =
                currentCmsObjectValue.value.copyWithNewValue(
              CmsAttributValue(
                name: cmsValue.name,
                value: newValue,
              ),
            );
          },
        );
      },
    );
  }
}

class _InsertButton extends StatefulWidget {
  final CmsObject cmsObject;
  final CmsObjectValue? existingCmsObjectValue;
  final CmsObjectValue currentCmsObjectValue;
  final ValueNotifier<bool> shouldDisplayValidationErrors;

  const _InsertButton({
    Key? key,
    required this.currentCmsObjectValue,
    required this.cmsObject,
    required this.existingCmsObjectValue,
    required this.shouldDisplayValidationErrors,
  }) : super(key: key);

  @override
  __InsertButtonState createState() => __InsertButtonState();
}

class __InsertButtonState extends State<_InsertButton> {
  final _isInserting = ValueNotifier(false);

  @override
  void dispose() {
    _isInserting.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: _isInserting,
        builder: (context, isInserting, child) {
          return ElevatedButton(
            onPressed: _onInsertObject,
            child: isInserting
                ? const CircularProgressIndicator()
                : const Text("Speichern"),
          );
        });
  }

  Future<void> _onInsertObject() async {
    final currentCmsObjectValue = widget.currentCmsObjectValue;
    if (!widget.cmsObject.isCmsObjectValueValid(currentCmsObjectValue)) {
      showErrorMessage(
        context: context,
        errorMessage: "Bitte überprüfe deine Eingaben",
      );
      widget.shouldDisplayValidationErrors.value = true;
      return;
    }

    _isInserting.value = true;

    final Result result;

    if (widget.existingCmsObjectValue != null) {
      result = widget.cmsObject.onUpdateCmsObject != null
          ? await widget.cmsObject.onUpdateCmsObject!(currentCmsObjectValue)
          : Result.success(const Unit());
    } else {
      result = widget.cmsObject.onCreateCmsObject != null
          ? await widget.cmsObject.onCreateCmsObject!(currentCmsObjectValue)
          : Result.success(const Unit());
    }

    result.fold(
      onError: (errorMessage) {
        _isInserting.value = false;
        showErrorMessage(
          context: context,
          errorMessage: errorMessage,
        );
      },
      onSuccess: (unit) => Navigator.of(context).pop(),
    );
  }
}
