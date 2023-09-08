import 'package:flutter/material.dart';
import 'package:flutter_admin_tool/data_types/attribute_implementations/flat_attribute_list/flat_attribute_list.dart';
import 'package:flutter_admin_tool/data_types/flat_attribute_structure.dart';
import 'package:flutter_admin_tool/data_types/flat_texts.dart';
import 'package:flutter_admin_tool/flat_app.dart';
import 'package:flutter_admin_tool/ui/widgets/flat_button.dart';

class FlatAttributeListWidget<T extends Object,
    S extends FlatAttributeStructure<T>> extends StatefulWidget {
  final List<T> currentValue;
  final FlatAttributeList<T, S> flatTypeList;
  final bool shouldDisplayValidationErrors;
  final OnFlatTypeUpdated<List<T>> onFlatTypeUpdated;
  final FlatAttributeStructure<T> flatAttributeStructure;

  const FlatAttributeListWidget({
    Key? key,
    required this.flatTypeList,
    required this.currentValue,
    required this.shouldDisplayValidationErrors,
    required this.onFlatTypeUpdated,
    required this.flatAttributeStructure,
  }) : super(key: key);

  @override
  State<FlatAttributeListWidget> createState() =>
      _FlatAttributeListWidgetState();
}

class _FlatAttributeListWidgetState extends State<FlatAttributeListWidget> {
  Object? _currentValue;
  bool _shouldDisplayCurrentValueValidationErrors = false;

  @override
  Widget build(BuildContext context) {
    final FlatTexts flatTexts = FlatApp.getFlatTexts(context);

    final isValid = widget.flatTypeList.isValid(
      widget.currentValue.isEmpty ? null : widget.currentValue,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          key: ValueKey(widget.currentValue.length),
          child: widget.flatAttributeStructure.buildWidget(
            currentValue: _currentValue,
            shouldDisplayValidationErrors:
                _shouldDisplayCurrentValueValidationErrors,
            onFlatTypeUpdated: (value) => setState(() => _currentValue = value),
          ),
        ),
        const SizedBox(height: 16),
        FlatButton(
            text: FlatApp.getFlatTexts(context).flatAttributeListAddItem,
            onPressed: () {
              if (!widget.flatAttributeStructure.isValid(_currentValue)) {
                setState(
                    () => _shouldDisplayCurrentValueValidationErrors = true);
                return;
              }

              if (_currentValue == null) return;

              widget.onFlatTypeUpdated(
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
              widget.flatAttributeStructure
                  .valueToString(context: context, value: item),
            ),
            trailing: IconButton(
              onPressed: () {
                final newList = List.of(widget.currentValue)..remove(item);
                widget.onFlatTypeUpdated(newList.isEmpty ? null : newList);
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
              widget.flatTypeList.invalidValueErrorMessage ??
                  flatTexts.defaultInvalidDataMessage,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  ),
            ),
          ),
      ],
    );
  }
}
