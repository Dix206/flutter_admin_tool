import 'package:flutter_admin_tool/data_types/attribute_implementations/flat_attribute_date/flat_attribute_date_widget.dart';
import 'package:flutter_admin_tool/flat_app.dart';
import 'package:intl/intl.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter_admin_tool/data_types/flat_attribute_structure.dart';

class FlatAttributeDate extends FlatAttributeStructure<DateTime> {
  final DateTime? minDateTime;
  final DateTime? maxDateTime;

  const FlatAttributeDate({
    required super.id,
    required super.displayName,
    this.minDateTime,
    this.maxDateTime,
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
    required DateTime? currentValue,
    required bool shouldDisplayValidationErrors,
    required OnFlatTypeUpdated<DateTime> onFlatTypeUpdated,
  }) =>
      FlatAttributeDateWidget(
        flatTypeDate: this,
        currentValue: currentValue,
        shouldDisplayValidationErrors: shouldDisplayValidationErrors,
        onFlatTypeUpdated: onFlatTypeUpdated,
        minDateTime: minDateTime,
        maxDateTime: maxDateTime,
      );

  @override
  String valueToString({
    required BuildContext context,
    required DateTime? value,
  }) =>
      value == null
          ? FlatApp.getFlatTexts(context).flatAttributeValueNull
          : DateFormat.yMd(Localizations.localeOf(context).languageCode).format(value);

  @override
  List<Object?> get props => [
        ...super.props,
        maxDateTime,
        minDateTime,
      ];
}
