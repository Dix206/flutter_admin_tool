import 'package:flutter/material.dart';
import 'package:flutter_cms/data_types/attribut_implementations/cms_attribut_list/cms_attribut_list.dart';
import 'package:flutter_cms/data_types/cms_attribut_structure.dart';
import 'package:flutter_cms/ui/messages/error_message.dart';
import 'package:flutter_cms/ui/widgets/cms_button.dart';

class CmsAttributListWidget<T extends Object, S extends CmsAttributStructure<T>> extends StatefulWidget {
  final List<T> currentValue;
  final CmsAttributList<T, S> cmsTypeList;
  final bool shouldDisplayValidationErrors;
  final OnCmsTypeUpdated<List<T>> onCmsTypeUpdated;
  final CmsAttributStructure<T> cmsAttributStructure;

  const CmsAttributListWidget({
    Key? key,
    required this.cmsTypeList,
    required this.currentValue,
    required this.shouldDisplayValidationErrors,
    required this.onCmsTypeUpdated,
    required this.cmsAttributStructure,
  }) : super(key: key);

  @override
  State<CmsAttributListWidget> createState() => _CmsAttributListWidgetState();
}

class _CmsAttributListWidgetState extends State<CmsAttributListWidget> {
  Object? _currentValue;
  bool _shouldDisplayCurrentValueValidationErrors = false;

  @override
  Widget build(BuildContext context) {
    final isValid = widget.cmsTypeList.isValid(
      widget.currentValue.isEmpty ? null : widget.currentValue,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          key: ValueKey(widget.currentValue.length),
          child: widget.cmsAttributStructure.buildWidget(
            currentValue: _currentValue,
            shouldDisplayValidationErrors: _shouldDisplayCurrentValueValidationErrors,
            onCmsTypeUpdated: (value) => setState(() => _currentValue = value),
          ),
        ),
        const SizedBox(height: 16),
        CmsButton(
            text: "Add item",
            onPressed: () {
              if (!widget.cmsAttributStructure.isValid(_currentValue)) {
                setState(() => _shouldDisplayCurrentValueValidationErrors = true);
                return;
              }

              if (_currentValue == null) {
                showErrorMessage(
                  context: context,
                  errorMessage: "You have to set a value",
                );
                return;
              }

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
              widget.cmsAttributStructure.valueToString(context: context, value: item),
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
              widget.cmsTypeList.invalidValueErrorMessage,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  ),
            ),
          ),
      ],
    );
  }
}
