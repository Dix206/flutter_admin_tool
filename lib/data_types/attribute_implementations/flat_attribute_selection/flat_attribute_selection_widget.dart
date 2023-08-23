import 'package:flutter/material.dart';
import 'package:flutter_admin_tool/data_types/attribute_implementations/flat_attribute_selection/flat_attribute_selection.dart';
import 'package:flutter_admin_tool/data_types/flat_attribute_structure.dart';
import 'package:flutter_admin_tool/data_types/flat_texts.dart';
import 'package:flutter_admin_tool/flat_app.dart';

class FlatAttributeSelectionWidget<T extends Object> extends StatelessWidget {
  final List<T> options;
  final T? currentValue;
  final OnFlatTypeUpdated<T> onFlatTypeUpdated;
  final bool shouldDisplayValidationErrors;
  final FlatAttributeSelection<T> flatTypeSelection;

  const FlatAttributeSelectionWidget({
    Key? key,
    required this.currentValue,
    required this.onFlatTypeUpdated,
    required this.options,
    required this.shouldDisplayValidationErrors,
    required this.flatTypeSelection,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FlatTexts flatTexts = FlatApp.getFlatTexts(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField<T>(
          value: currentValue,
          onChanged: onFlatTypeUpdated,
          items: options
              .map(
                (option) => DropdownMenuItem<T>(
                  value: option,
                  child: Text(flatTypeSelection.optionToString(option)),
                ),
              )
              .toList(),
          decoration: InputDecoration(
            prefixIcon: currentValue != null
                ? InkWell(
                    child: const Icon(Icons.close),
                    onTap: () => onFlatTypeUpdated(null),
                  )
                : null,
            hintText: FlatApp.getFlatTexts(context).flatAttributeSelectionNoItemSelected,
            border: const OutlineInputBorder(),
          ),
        ),
        if (shouldDisplayValidationErrors && !flatTypeSelection.isValid(currentValue))
          Padding(
            padding: const EdgeInsets.only(
              top: 8.0,
              left: 16,
              right: 16,
            ),
            child: Text(
              flatTypeSelection.invalidValueErrorMessage ?? flatTexts.defaultInvalidDataMessage,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  ),
            ),
          ),
      ],
    );
  }
}
