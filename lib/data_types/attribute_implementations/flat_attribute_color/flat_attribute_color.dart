import 'package:flutter/widgets.dart';
import 'package:flutter_admin_tool/data_types/attribute_implementations/flat_attribute_color/flat_attribute_color_widget.dart';
import 'package:flutter_admin_tool/data_types/flat_attribute_structure.dart';
import 'package:flutter_admin_tool/flat_app.dart';

class FlatAttributeColor extends FlatAttributeStructure<Color> {
  const FlatAttributeColor({
    required super.id,
    required super.displayName,
    super.defaultValue,
    super.isOptional = false,
    super.canBeEdited = true,
    super.validator,
    super.invalidValueErrorMessage,
  }) : super(
          canObjectBeSortedByThisAttribute: false,
          shouldBeDisplayedOnOverviewTable: false,
        );

  @override
  Widget buildWidget({
    required Color? currentValue,
    required bool shouldDisplayValidationErrors,
    required OnFlatTypeUpdated<Color> onFlatTypeUpdated,
  }) =>
      FlatAttributeColorWidget(
        title: displayName,
        currentValue: currentValue,
        onFlatTypeUpdated: onFlatTypeUpdated,
        flatAttributeColor: this,
        shouldDisplayValidationErrors: shouldDisplayValidationErrors,
      );

  @override
  String valueToString({
    required BuildContext context,
    required Color? value,
  }) =>
      value != null ? "#${value.value.toRadixString(16).padLeft(8, '0').toUpperCase()}" : FlatApp.getFlatTexts(context).flatAttributeValueNull;
}
