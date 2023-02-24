import 'package:flutter/material.dart';
import 'package:flutter_cms/data_types/attribute_implementations/cms_attribute_selection/cms_attribute_selection.dart';
import 'package:flutter_cms/data_types/cms_attribute_structure.dart';
import 'package:flutter_cms/data_types/cms_texts.dart';
import 'package:flutter_cms/flutter_cms.dart';

class CmsAttributeSelectionWidget<T extends Object> extends StatelessWidget {
  final List<T> options;
  final T? currentValue;
  final OnCmsTypeUpdated<T> onCmsTypeUpdated;
  final bool shouldDisplayValidationErrors;
  final CmsAttributeSelection<T> cmsTypeSelection;

  const CmsAttributeSelectionWidget({
    Key? key,
    required this.currentValue,
    required this.onCmsTypeUpdated,
    required this.options,
    required this.shouldDisplayValidationErrors,
    required this.cmsTypeSelection,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CmsTexts cmsTexts = FlutterCms.getCmsTexts(context);

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
          decoration: InputDecoration(
            prefixIcon: currentValue != null
                ? InkWell(
                    child: const Icon(Icons.close),
                    onTap: () => onCmsTypeUpdated(null),
                  )
                : null,
            hintText: FlutterCms.getCmsTexts(context).cmsAttributeSelectionNoItemSelected,
            border: const OutlineInputBorder(),
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
              cmsTypeSelection.invalidValueErrorMessage ?? cmsTexts.defaultInvalidDataMessage,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  ),
            ),
          ),
      ],
    );
  }
}
