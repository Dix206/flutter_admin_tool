import 'package:flutter/widgets.dart';
import 'package:flutter_admin_tool/data_types/attribute_implementations/flat_attribute_double/flat_attribute_double_widget.dart';
import 'package:flutter_admin_tool/data_types/flat_attribute_structure.dart';
import 'package:flutter_admin_tool/flat_app.dart';

class FlatAttributeDouble extends FlatAttributeStructure<double> {
  final String? hint;

  const FlatAttributeDouble({
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
    required double? currentValue,
    required bool shouldDisplayValidationErrors,
    required OnFlatTypeUpdated<double> onFlatTypeUpdated,
  }) =>
      FlatAttributeDoubleWidget(
        flatTypeDouble: this,
        currentValue: currentValue,
        shouldDisplayValidationErrors: shouldDisplayValidationErrors,
        onFlatTypeUpdated: onFlatTypeUpdated,
      );

  @override
  String valueToString({
    required BuildContext context,
    required double? value,
  }) =>
      value?.toString() ?? FlatApp.getFlatTexts(context).flatAttributeValueNull;

  @override
  List<Object?> get props => [
        ...super.props,
        hint,
      ];
}
