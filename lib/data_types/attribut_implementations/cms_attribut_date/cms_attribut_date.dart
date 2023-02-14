import 'package:flutter_cms/data_types/attribut_implementations/cms_attribut_date/cms_attribute_date_widget.dart';
import 'package:intl/intl.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter_cms/data_types/cms_attribut_structure.dart';

class CmsAttributDate extends CmsAttributStructure<DateTime> {
  final DateTime? minDateTime;
  final DateTime? maxDateTime;

  const CmsAttributDate({
    required super.id,
    required super.displayName,
    this.minDateTime,
    this.maxDateTime,
    super.defaultValue,
    super.validator,
    super.invalidValueErrorMessage = "invalid input",
    super.isOptional = false,
    super.canObjectBeSortedByThisAttribut = false,
    super.shouldBeDisplayedOnOverviewTable = true,
  });

  @override
  Widget buildWidget({
    required DateTime? currentValue,
    required bool shouldDisplayValidationErrors,
    required OnCmsTypeUpdated<DateTime> onCmsTypeUpdated,
  }) =>
      CmsAttributDateWidget(
        cmsTypeDate: this,
        currentValue: currentValue,
        shouldDisplayValidationErrors: shouldDisplayValidationErrors,
        onCmsTypeUpdated: onCmsTypeUpdated,
        minDateTime: minDateTime,
        maxDateTime: maxDateTime,
      );

  @override
  String valueToString({
    required BuildContext context,
    required DateTime? value,
  }) =>
      value == null ? "---" : DateFormat.yMd(Localizations.localeOf(context).languageCode).format(value);

  @override
  List<Object?> get props => [
        ...super.props,
        maxDateTime,
        minDateTime,
      ];
}
