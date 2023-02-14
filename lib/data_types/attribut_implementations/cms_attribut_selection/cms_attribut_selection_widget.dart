import 'package:flutter/material.dart';
import 'package:flutter_cms/data_types/attribut_implementations/cms_attribut_selection/cms_attribut_selection.dart';
import 'package:flutter_cms/data_types/cms_attribut_structure.dart';

class CmsAttributSelectionWidget<T extends Object> extends StatelessWidget {
  final List<T> options;
  final T? currentValue;
  final OnCmsTypeUpdated<T> onCmsTypeUpdated;
  final bool shouldDisplayValidationErrors;
  final CmsAttributSelection<T> cmsTypeSelection;

  const CmsAttributSelectionWidget({
    Key? key,
    required this.currentValue,
    required this.onCmsTypeUpdated,
    required this.options,
    required this.shouldDisplayValidationErrors,
    required this.cmsTypeSelection,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField<T>(
          value: currentValue,
          onChanged: onCmsTypeUpdated,
          items: options
              .map(
                (option) => DropdownMenuItem<T>(
                  value: option,
                  child: Text(cmsTypeSelection.optionToString(option)),
                ),
              )
              .toList(),
          decoration: const InputDecoration(
            hintText: "No item selected",
            border: OutlineInputBorder(),
          ),
        ),
        if (shouldDisplayValidationErrors && !cmsTypeSelection.isValid(currentValue))
          Padding(
            padding: const EdgeInsets.only(
              top: 8.0,
              left: 16,
              right: 16,
            ),
            child: Text(
              cmsTypeSelection.invalidValueErrorMessage,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  ),
            ),
          ),
      ],
    );
  }
}
