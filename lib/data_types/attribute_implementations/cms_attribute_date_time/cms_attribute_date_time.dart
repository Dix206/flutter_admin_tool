import 'package:flutter_cms/flutter_cms.dart';
import 'package:intl/intl.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_cms/data_types/attribute_implementations/cms_attribute_date_time/cms_attribute_date_time_widget.dart';

import 'package:flutter_cms/data_types/cms_attribute_structure.dart';

class CmsAttributeDateTime extends CmsAttributeStructure<DateTime> {
  final DateTime? minDateTime;
  final DateTime? maxDateTime;

  const CmsAttributeDateTime({
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
      CmsAttributeDateTimeWidget(
        cmsTypeDateTime: this,
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
          : "${DateFormat.yMd(Localizations.localeOf(context).languageCode).format(value)} ${DateFormat.Hm(Localizations.localeOf(context).languageCode).format(value)}";

  @override
  List<Object?> get props => [
        ...super.props,
        maxDateTime,
        minDateTime,
      ];
}
