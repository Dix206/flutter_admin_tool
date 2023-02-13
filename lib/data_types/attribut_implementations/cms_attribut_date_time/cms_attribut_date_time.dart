import 'package:intl/intl.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_cms/data_types/attribut_implementations/cms_attribut_date_time/cms_attribut_date_time_widget.dart';

import 'package:flutter_cms/data_types/cms_attribut_structure.dart';

class CmsAttributDateTime extends CmsAttributStructure<DateTime> {
  final DateTime? minDateTime;
  final DateTime? maxDateTime;

  const CmsAttributDateTime({
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
    required BuildContext context,
    required DateTime? currentValue,
    required bool shouldDisplayValidationErrors,
    required OnCmsTypeUpdated<DateTime> onCmsTypeUpdated,
  }) =>
      CmsAttributDateTimeWidget(
        context: context,
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
          ? "---"
          : "${DateFormat.yMd(Localizations.localeOf(context).languageCode).format(value)} ${DateFormat.Hm(Localizations.localeOf(context).languageCode).format(value)}";

  @override
  List<Object?> get props => [
        ...super.props,
        maxDateTime,
        minDateTime,
      ];
}
