import 'package:flutter/widgets.dart';
import 'package:flutter_admin_tool/data_types/attribute_implementations/flat_attribute_bool/flat_attribute_bool_widget.dart';
import 'package:flutter_admin_tool/data_types/flat_attribute_structure.dart';
import 'package:flutter_admin_tool/flat_app.dart';

class FlatAttributeBool extends FlatAttributeStructure<bool> {
  const FlatAttributeBool({
    required super.id,
    required super.displayName,
    super.defaultValue = false,
    super.canBeEdited = true,
    super.canObjectBeSortedByThisAttribute = false,
    super.shouldBeDisplayedOnOverviewTable = true,
  }) : super(
          isOptional: false,
          validator: null,
          invalidValueErrorMessage: null,
        );

  @override
  Widget buildWidget({
    required bool? currentValue,
    required bool shouldDisplayValidationErrors,
    required OnFlatTypeUpdated<bool> onFlatTypeUpdated,
  }) =>
      FlatAttributeBoolWidget(
        title: displayName,
        currentValue: currentValue ?? false,
        onFlatTypeUpdated: onFlatTypeUpdated,
      );

  @override
  String valueToString({
    required BuildContext context,
    required bool? value,
  }) =>
      value?.toString() ?? FlatApp.getFlatTexts(context).flatAttributeValueNull;
}
