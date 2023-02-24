import 'package:flutter/material.dart';
import 'package:flutter_cms/data_types/attribute_implementations/cms_attribute_list/cms_attribute_list.dart';
import 'package:flutter_cms/data_types/cms_attribute_structure.dart';
import 'package:flutter_cms/data_types/cms_texts.dart';
import 'package:flutter_cms/flutter_cms.dart';
import 'package:flutter_cms/ui/widgets/cms_button.dart';

class CmsAttributeListWidget<T extends Object, S extends CmsAttributeStructure<T>> extends StatefulWidget {
  final List<T> currentValue;
  final CmsAttributeList<T, S> cmsTypeList;
  final bool shouldDisplayValidationErrors;
  final OnCmsTypeUpdated<List<T>> onCmsTypeUpdated;
  final CmsAttributeStructure<T> cmsAttributeStructure;

  const CmsAttributeListWidget({
    Key? key,
    required this.cmsTypeList,
    required this.currentValue,
    required this.shouldDisplayValidationErrors,
    required this.onCmsTypeUpdated,
    required this.cmsAttributeStructure,
  }) : super(key: key);

  @override
  State<CmsAttributeListWidget> createState() => _CmsAttributeListWidgetState();
}

class _CmsAttributeListWidgetState extends State<CmsAttributeListWidget> {
  Object? _currentValue;
  bool _shouldDisplayCurrentValueValidationErrors = false;

  @override
  Widget build(BuildContext context) {
    final CmsTexts cmsTexts = FlutterCms.getCmsTexts(context);

    final isValid = widget.cmsTypeList.isValid(
      widget.currentValue.isEmpty ? null : widget.currentValue,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          key: ValueKey(widget.currentValue.length),
          child: widget.cmsAttributeStructure.buildWidget(
            currentValue: _currentValue,
            shouldDisplayValidationErrors: _shouldDisplayCurrentValueValidationErrors,
            onCmsTypeUpdated: (value) => setState(() => _currentValue = value),
          ),
        ),
        const SizedBox(height: 16),
        CmsButton(
            text: FlutterCms.getCmsTexts(context).cmsAttributeListAddItem,
            onPressed: () {
              if (!widget.cmsAttributeStructure.isValid(_currentValue)) {
                setState(() => _shouldDisplayCurrentValueValidationErrors = true);
                return;
              }

              if (_currentValue == null) return;

              widget.onCmsTypeUpdated(
                List.of(widget.currentValue)..add(_currentValue!),
              );
              setState(() {
                _currentValue = null;
                _shouldDisplayCurrentValueValidationErrors = false;
              });
            }),
        if (widget.currentValue.isNotEmpty) ...[
          const SizedBox(height: 16),
          const Divider(),
        ],
        ...widget.currentValue.map(
          (item) => ListTile(
            title: Text(
              widget.cmsAttributeStructure.valueToString(context: context, value: item),
            ),
            trailing: IconButton(
              onPressed: () {
                final newList = List.of(widget.currentValue)..remove(item);
                widget.onCmsTypeUpdated(newList.isEmpty ? null : newList);
              },
              icon: const Icon(Icons.delete),
            ),
          ),
        ),
        if (!isValid && widget.shouldDisplayValidationErrors)
          Padding(
            padding: const EdgeInsets.only(
              top: 8.0,
              left: 16.0,
              right: 16.0,
            ),
            child: Text(
              widget.cmsTypeList.invalidValueErrorMessage ?? cmsTexts.defaultInvalidDataMessage,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  ),
            ),
          ),
      ],
    );
  }
}
