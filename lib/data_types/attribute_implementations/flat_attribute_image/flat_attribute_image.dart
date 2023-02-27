import 'package:flutter/widgets.dart';

import 'package:flat/data_types/attribute_implementations/flat_attribute_image/flat_attribute_image_widget.dart';
import 'package:flat/data_types/flat_attribute_structure.dart';
import 'package:flat/data_types/flat_file_value.dart';
import 'package:flat/flat_app.dart';

class FlatAttributeImage extends FlatAttributeStructure<FlatFileValue> {
  const FlatAttributeImage({
    required super.id,
    required super.displayName,
    super.isOptional = false,
    super.invalidValueErrorMessage,
  }) : super(
          validator: null,
          defaultValue: null,
          shouldBeDisplayedOnOverviewTable: false,
          canObjectBeSortedByThisAttribute: false,
        );

  @override
  Widget buildWidget({
    required FlatFileValue? currentValue,
    required bool shouldDisplayValidationErrors,
    required OnFlatTypeUpdated<FlatFileValue> onFlatTypeUpdated,
  }) =>
      FlatAttributeImageWidget(
        flatTypeImage: this,
        currentValue: currentValue,
        shouldDisplayValidationErrors: shouldDisplayValidationErrors,
        onFlatTypeUpdated: onFlatTypeUpdated,
      );

  @override
  String valueToString({
    required BuildContext context,
    required FlatFileValue? value,
  }) =>
      value?.url ?? FlatApp.getFlatTexts(context).flatAttributeValueNull;

  @override
  bool isValid(FlatFileValue? value) {
    return value?.data != null || (value?.url != null && value?.wasDeleted == false) || isOptional;
  }
}
