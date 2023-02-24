import 'package:flutter/material.dart';
import 'package:flutter_cms/data_types/attribute_implementations/cms_attribute_time/cms_attribute_time_widget.dart';
import 'package:flutter_cms/flutter_cms.dart';
import 'package:intl/intl.dart';

import 'package:flutter_cms/data_types/cms_attribute_structure.dart';

class CmsAttributeTime extends CmsAttributeStructure<TimeOfDay> {
  const CmsAttributeTime({
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
    required TimeOfDay? currentValue,
    required bool shouldDisplayValidationErrors,
    required OnCmsTypeUpdated<TimeOfDay> onCmsTypeUpdated,
  }) =>
      CmsAttributeTimeWidget(
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
          ? FlutterCms.getCmsTexts(context).cmsAttributeValueNull
          : DateFormat.Hm(Localizations.localeOf(context).languageCode).format(
              DateTime(1, 1, 1, value.hour, value.minute),
            );
}
