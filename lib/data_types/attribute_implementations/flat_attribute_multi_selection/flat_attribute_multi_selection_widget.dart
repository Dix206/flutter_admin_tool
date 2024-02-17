import 'package:flutter/material.dart';
import 'package:flutter_admin_tool/data_types/attribute_implementations/flat_attribute_multi_selection/flat_attribute_multi_selection.dart';
import 'package:flutter_admin_tool/data_types/flat_attribute_structure.dart';
import 'package:flutter_admin_tool/data_types/flat_texts.dart';
import 'package:flutter_admin_tool/flat_app.dart';

class FlatAttributeMultiSelectionWidget<T extends Object> extends StatelessWidget {
  final List<T> options;
  final List<T>? currentValue;
  final OnFlatTypeUpdated<List<T>> onFlatTypeUpdated;
  final bool shouldDisplayValidationErrors;
  final FlatAttributeMultiSelection<T> flatMultiTypeSelection;

  const FlatAttributeMultiSelectionWidget({
    super.key,
    required this.currentValue,
    required this.onFlatTypeUpdated,
    required this.options,
    required this.shouldDisplayValidationErrors,
    required this.flatMultiTypeSelection,
  });

  @override
  Widget build(BuildContext context) {
    final FlatTexts flatTexts = FlatApp.getFlatTexts(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...options.map(
          (option) => CheckboxListTile(
            value: currentValue?.contains(option) ?? false,
            onChanged: (_) {
              final List<T> newValue = currentValue != null && currentValue!.contains(option)
                  ? currentValue!.where((e) => e != option).toList()
                  : [...(currentValue ?? []), option];
              onFlatTypeUpdated(newValue.cast());
            },
            title: Text(flatMultiTypeSelection.optionToString(option)),
          ),
        ),
        if (shouldDisplayValidationErrors && !flatMultiTypeSelection.isValid(currentValue))
          Padding(
            padding: const EdgeInsets.only(
              top: 8.0,
              left: 16,
              right: 16,
            ),
            child: Text(
              flatMultiTypeSelection.invalidValueErrorMessage ?? flatTexts.defaultInvalidDataMessage,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  ),
            ),
          ),
      ],
    );
  }
}
