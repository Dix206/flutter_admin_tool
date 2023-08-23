import 'package:flutter/widgets.dart';
import 'package:flutter_admin_tool/data_types/attribute_implementations/flat_attribute_reference/flat_attribute_reference_widget.dart';

import 'package:flutter_admin_tool/data_types/flat_attribute_structure.dart';
import 'package:flutter_admin_tool/data_types/flat_result.dart';
import 'package:flutter_admin_tool/flat_app.dart';

/// T is the type of the reference which will be setted
class FlatAttributeReference<T extends Object> extends FlatAttributeStructure<T> {
  final Future<FlatResult<List<T>>> Function(String searchQuery) searchFunction;
  final String Function(T value) getReferenceDisplayString;

  const FlatAttributeReference({
    required this.searchFunction,
    required this.getReferenceDisplayString,
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
    required T? currentValue,
    required bool shouldDisplayValidationErrors,
    required OnFlatTypeUpdated<T> onFlatTypeUpdated,
  }) =>
      FlatAttributeReferenceWidget(
        flatTypeReference: this,
        currentValue: currentValue,
        shouldDisplayValidationErrors: shouldDisplayValidationErrors,
        onFlatTypeUpdated: onFlatTypeUpdated,
      );

  @override
  String valueToString({
    required BuildContext context,
    required T? value,
  }) =>
      value == null ? FlatApp.getFlatTexts(context).flatAttributeValueNull : getReferenceDisplayString(value);

  @override
  List<Object?> get props => [
        ...super.props,
        searchFunction,
        getReferenceDisplayString,
      ];
}
