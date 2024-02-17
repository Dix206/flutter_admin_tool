import 'package:flutter/widgets.dart';
import 'package:flutter_admin_tool/data_types/attribute_implementations/flat_attribute_multi_selection/flat_attribute_multi_selection_widget.dart';

import 'package:flutter_admin_tool/data_types/flat_attribute_structure.dart';
import 'package:flutter_admin_tool/flat_app.dart';

class FlatAttributeMultiSelection<T extends Object> extends FlatAttributeStructure<List<T>> {
  final List<T> options;

  /// Converts an option to a string that can be displayed to the user.
  final String Function(T) optionToString;

  const FlatAttributeMultiSelection({
    required this.options,
    required this.optionToString,
    required super.id,
    required super.displayName,
    super.defaultValue,
    super.invalidValueErrorMessage,
    super.isOptional = false,
    super.canBeEdited = true,
    super.canObjectBeSortedByThisAttribute = false,
    super.shouldBeDisplayedOnOverviewTable = true,
  }) : super(
          validator: null,
        );

  @override
  Widget buildWidget({
    required List<T>? currentValue,
    required bool shouldDisplayValidationErrors,
    required OnFlatTypeUpdated<List<T>> onFlatTypeUpdated,
  }) =>
      FlatAttributeMultiSelectionWidget(
        flatMultiTypeSelection: this,
        currentValue: currentValue,
        shouldDisplayValidationErrors: shouldDisplayValidationErrors,
        onFlatTypeUpdated: onFlatTypeUpdated,
        options: options,
      );

  @override
  String valueToString({
    required BuildContext context,
    required List<T>? value,
  }) =>
      value == null || value.isEmpty
          ? FlatApp.getFlatTexts(context).flatAttributeValueNull
          : value.map((value) => optionToString(value)).join(', ');

  @override
  List<Object?> get props => [
        ...super.props,
        options,
        optionToString,
      ];
}
