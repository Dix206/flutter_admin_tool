import 'package:flutter/widgets.dart';
import 'package:flat/data_types/attribute_implementations/flat_attribute_html/flat_attribute_html_widget.dart';

import 'package:flat/data_types/flat_attribute_structure.dart';
import 'package:flat/flat_app.dart';

class FlatAttributeHtml extends FlatAttributeStructure<String> {
  const FlatAttributeHtml({
    required super.id,
    required super.displayName,
    super.defaultValue,
    super.validator,
    super.invalidValueErrorMessage,
    super.isOptional = false,
    super.canObjectBeSortedByThisAttribute = false,
    super.shouldBeDisplayedOnOverviewTable = true,
  });

  @override
  Widget buildWidget({
    required String? currentValue,
    required bool shouldDisplayValidationErrors,
    required OnFlatTypeUpdated<String> onFlatTypeUpdated,
  }) =>
      FlatAttributeHtmlWidget(
        flatTypeHtml: this,
        currentValue: currentValue,
        shouldDisplayValidationErrors: shouldDisplayValidationErrors,
        onFlatTypeUpdated: onFlatTypeUpdated,
      );

  @override
  bool isValid(String? value) {
    return (value?.trim().isNotEmpty == true && (validator?.call(value) ?? true)) ||
        (value?.trim().isNotEmpty != false && isOptional);
  }

  @override
  String valueToString({
    required BuildContext context,
    required String? value,
  }) =>
      value ?? FlatApp.getFlatTexts(context).flatAttributeValueNull;
}
