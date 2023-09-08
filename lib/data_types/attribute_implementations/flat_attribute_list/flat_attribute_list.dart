import 'package:flutter/widgets.dart';
import 'package:flutter_admin_tool/data_types/attribute_implementations/flat_attribute_list/flat_attribute_list_widget.dart';

import 'package:flutter_admin_tool/data_types/flat_attribute_structure.dart';
import 'package:flutter_admin_tool/flat_app.dart';

class FlatAttributeList<T extends Object, S extends FlatAttributeStructure<T>>
    extends FlatAttributeStructure<List> {
  final FlatAttributeStructure<T> flatAttributeStructure;

  const FlatAttributeList({
    required this.flatAttributeStructure,
    required super.id,
    required super.displayName,
    super.defaultValue,
    super.invalidValueErrorMessage,
    super.isOptional = false,
    super.canBeEdited = true,
    super.validator,
    super.canObjectBeSortedByThisAttribute = false,
    super.shouldBeDisplayedOnOverviewTable = true,
  });

  @override
  Widget buildWidget({
    required List? currentValue,
    required bool shouldDisplayValidationErrors,
    required OnFlatTypeUpdated<List<T>> onFlatTypeUpdated,
  }) {
    return FlatAttributeListWidget<T, S>(
      flatTypeList: this,
      currentValue: currentValue?.cast() ?? [],
      shouldDisplayValidationErrors: shouldDisplayValidationErrors,
      onFlatTypeUpdated: onFlatTypeUpdated,
      flatAttributeStructure: flatAttributeStructure,
    );
  }

  @override
  String valueToString({
    required BuildContext context,
    required List? value,
  }) =>
      value == null
          ? FlatApp.getFlatTexts(context).flatAttributeValueNull
          : value
              .map(
                (item) => flatAttributeStructure.valueToString(
                    context: context, value: item),
              )
              .join(" | ");

  @override
  List<Object?> get props => [
        ...super.props,
        flatAttributeStructure,
      ];
}
