import 'package:flutter/material.dart';
import 'package:flutter_admin_tool/data_types/attribute_implementations/flat_attribute_time/flat_attribute_time_widget.dart';
import 'package:flutter_admin_tool/flat_app.dart';
import 'package:intl/intl.dart';

import 'package:flutter_admin_tool/data_types/flat_attribute_structure.dart';

class FlatAttributeTime extends FlatAttributeStructure<TimeOfDay> {
  const FlatAttributeTime({
    required super.id,
    required super.displayName,
    super.defaultValue,
    super.validator,
    super.invalidValueErrorMessage,
    super.isOptional = false,
    super.canBeEdited = true,
    super.canObjectBeSortedByThisAttribute = false,
    super.shouldBeDisplayedOnOverviewTable = true,
  });

  @override
  Widget buildWidget({
    required TimeOfDay? currentValue,
    required bool shouldDisplayValidationErrors,
    required OnFlatTypeUpdated<TimeOfDay> onFlatTypeUpdated,
  }) =>
      FlatAttributeTimeWidget(
        flatTypeTime: this,
        currentValue: currentValue,
        shouldDisplayValidationErrors: shouldDisplayValidationErrors,
        onFlatTypeUpdated: onFlatTypeUpdated,
      );

  @override
  String valueToString({
    required BuildContext context,
    required TimeOfDay? value,
  }) =>
      value == null
          ? FlatApp.getFlatTexts(context).flatAttributeValueNull
          : DateFormat.Hm(Localizations.localeOf(context).languageCode).format(
              DateTime(1, 1, 1, value.hour, value.minute),
            );
}
