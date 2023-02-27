import 'package:flutter/widgets.dart';

import 'package:flat/data_types/attribute_implementations/flat_attribute_string/flat_attribute_string_widget.dart';
import 'package:flat/data_types/flat_attribute_structure.dart';
import 'package:flat/flat_app.dart';

class FlatAttributeString extends FlatAttributeStructure<String> {
  final String? hint;
  final bool isMultiline;
  final int? maxLength;

  const FlatAttributeString({
    this.hint,
    required super.id,
    required super.displayName,
    super.defaultValue,
    this.isMultiline = false,
    this.maxLength,
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
      FlatAttributeStringWidget(
        flatTypeString: this,
        currentValue: currentValue,
        shouldDisplayValidationErrors: shouldDisplayValidationErrors,
        onFlatTypeUpdated: onFlatTypeUpdated,
        maxLength: maxLength,
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

  @override
  List<Object?> get props => [
        ...super.props,
        hint,
        isMultiline,
        maxLength,
      ];
}
