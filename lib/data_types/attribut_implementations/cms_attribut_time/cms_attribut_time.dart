import 'package:flutter/material.dart';
import 'package:flutter_cms/data_types/attribut_implementations/cms_attribut_time/cms_attribut_time_widget.dart';
import 'package:intl/intl.dart';

import 'package:flutter_cms/data_types/cms_attribut_structure.dart';

class CmsAttributTime extends CmsAttributStructure<TimeOfDay> {
  const CmsAttributTime({
    required super.id,
    required super.displayName,
    super.defaultValue,
    super.validator,
    super.invalidValueErrorMessage = "invalid input",
    super.isOptional = false,
    super.canObjectBeSortedByThisAttribut = false,
    super.shouldBeDisplayedOnOverviewTable = true,
  });

  @override
  Widget buildWidget({
    required BuildContext context,
    required TimeOfDay? currentValue,
    required bool shouldDisplayValidationErrors,
    required OnCmsTypeUpdated<TimeOfDay> onCmsTypeUpdated,
  }) =>
      CmsAttributTimeWidget(
        context: context,
        cmsTypeTime: this,
        currentValue: currentValue,
        shouldDisplayValidationErrors: shouldDisplayValidationErrors,
        onCmsTypeUpdated: onCmsTypeUpdated,
      );

  @override
  String valueToString({
    required BuildContext context,
    required TimeOfDay? value,
  }) =>
      value == null
          ? "---"
          : DateFormat.Hm(Localizations.localeOf(context).languageCode).format(
              DateTime(1, 1, 1, value.hour, value.minute),
            );
}
