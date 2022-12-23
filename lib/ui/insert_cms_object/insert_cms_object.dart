import 'package:flutter/material.dart';
import 'package:flutter_cms/data_types/cms_attribut_value.dart';
import 'package:flutter_cms/data_types/cms_object.dart';
import 'package:flutter_cms/data_types/cms_object_value.dart';
import 'package:flutter_cms/data_types/result.dart';
import 'package:flutter_cms/ui/flutter_cms_widget.dart';

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
          if (snapshot.data == null) return const Center(child: CircularProgressIndicator());

          return snapshot.data!.fold(
            onError: (errorMessage) => Text(errorMessage),
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
  final _isInserting = ValueNotifier(false);
  late final _currentCmsObjectValue = ValueNotifier(
    widget.cmsObject.toEmptyCmsObjectValue(),
  );

  @override
  void dispose() {
    _shouldDisplayValidationErrors.dispose();
    _isInserting.dispose();
    _currentCmsObjectValue.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ValueListenableBuilder(
              valueListenable: _currentCmsObjectValue,
              builder: (context, currentCmsObjectValue, child) {
                return ValueListenableBuilder(
                    valueListenable: _shouldDisplayValidationErrors,
                    builder: (context, shouldDisplayValidationErrors, child) {
                      return ListView.separated(
                        itemCount: widget.cmsObject.attributes.length,
                        separatorBuilder: (context, index) => const SizedBox(height: 24),
                        itemBuilder: (context, index) {
                          final cmsValue = widget.cmsObject.attributes[index];

                          return cmsValue.buildWidget(
                            context: context,
                            currentValue: currentCmsObjectValue.getAttributeValueByName(cmsValue.name)?.value ??
                                widget.existingCmsObjectValue?.values[index].value,
                            shouldDisplayValidationErrors: shouldDisplayValidationErrors,
                            onCmsTypeUpdated: (newValue) {
                              _currentCmsObjectValue.value = currentCmsObjectValue.copyWithNewValue(
                                CmsAttributValue(
                                  name: cmsValue.name,
                                  value: newValue,
                                ),
                              );
                            },
                          );
                        },
                      );
                    });
              }),
        ),
        ValueListenableBuilder(
            valueListenable: _isInserting,
            builder: (context, isInserting, child) {
              return ElevatedButton(
                onPressed: () async {
                  final currentCmsObjectValue = _currentCmsObjectValue.value;
                  if (!widget.cmsObject.isCmsObjectValueValid(currentCmsObjectValue)) {
                    _shouldDisplayValidationErrors.value = true;
                    return;
                  }

                  _isInserting.value = true;

                  final result = widget.existingCmsObjectValue != null && widget.cmsObject.onUpdateCmsObject != null
                      ? await widget.cmsObject.onUpdateCmsObject!(currentCmsObjectValue)
                      : widget.cmsObject.onCreateCmsObject != null
                          ? await widget.cmsObject.onCreateCmsObject!(currentCmsObjectValue)
                          : Result.success(const Unit());

                  result.fold(
                    onError: (errorMessage) {
                      _isInserting.value = false;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(errorMessage),
                        ),
                      );
                    },
                    onSuccess: (unit) => Navigator.of(context).pop(),
                  );
                },
                child: isInserting ? const CircularProgressIndicator() : const Text("Speichern"),
              );
            }),
      ],
    );
  }
}
