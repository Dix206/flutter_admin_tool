import 'package:flutter/widgets.dart';
import 'package:flat/data_types/attribute_implementations/flat_attribute_int/flat_attribute_int_widget.dart';
import 'package:flat/data_types/flat_attribute_structure.dart';
import 'package:flat/flat_app.dart';

class FlatAttributeInt extends FlatAttributeStructure<int> {
  final String? hint;

  const FlatAttributeInt({
    this.hint,
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
    required int? currentValue,
    required bool shouldDisplayValidationErrors,
    required OnFlatTypeUpdated<int> onFlatTypeUpdated,
  }) =>
      FlatAttributeIntWidget(
        flatTypeInt: this,
        currentValue: currentValue,
        shouldDisplayValidationErrors: shouldDisplayValidationErrors,
        onFlatTypeUpdated: onFlatTypeUpdated,
      );

  @override
  String valueToString({
    required BuildContext context,
    required int? value,
  }) =>
      value?.toString() ?? FlatApp.getFlatTexts(context).flatAttributeValueNull;

  @override
  List<Object?> get props => [
        ...super.props,
        hint,
      ];
}
