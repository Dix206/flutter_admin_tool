import 'package:flutter_cms/data_types/attribute_implementations/cms_attribute_date/cms_attribute_date_widget.dart';
import 'package:flutter_cms/flutter_cms.dart';
import 'package:intl/intl.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter_cms/data_types/cms_attribute_structure.dart';

class CmsAttributeDate extends CmsAttributeStructure<DateTime> {
  final DateTime? minDateTime;
  final DateTime? maxDateTime;

  const CmsAttributeDate({
    required super.id,
    required super.displayName,
    this.minDateTime,
    this.maxDateTime,
    super.defaultValue,
    super.validator,
    super.invalidValueErrorMessage,
    super.isOptional = false,
    super.canObjectBeSortedByThisAttribute = false,
    super.shouldBeDisplayedOnOverviewTable = true,
  });

  @override
  Widget buildWidget({
    required DateTime? currentValue,
    required bool shouldDisplayValidationErrors,
    required OnCmsTypeUpdated<DateTime> onCmsTypeUpdated,
  }) =>
      CmsAttributeDateWidget(
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
      value == null
          ? FlutterCms.getCmsTexts(context).cmsAttributeValueNull
          : DateFormat.yMd(Localizations.localeOf(context).languageCode).format(value);

  @override
  List<Object?> get props => [
        ...super.props,
        maxDateTime,
        minDateTime,
      ];
}
