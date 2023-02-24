import 'package:flutter/widgets.dart';
import 'package:flutter_cms/data_types/attribute_implementations/cms_attribute_double/cms_attribute_double_widget.dart';
import 'package:flutter_cms/data_types/cms_attribute_structure.dart';
import 'package:flutter_cms/flutter_cms.dart';

class CmsAttributeDouble extends CmsAttributeStructure<double> {
  final String? hint;

  const CmsAttributeDouble({
    this.hint,
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
    required double? currentValue,
    required bool shouldDisplayValidationErrors,
    required OnCmsTypeUpdated<double> onCmsTypeUpdated,
  }) =>
      CmsAttributeDoubleWidget(
        cmsTypeDouble: this,
        currentValue: currentValue,
        shouldDisplayValidationErrors: shouldDisplayValidationErrors,
        onCmsTypeUpdated: onCmsTypeUpdated,
      );

  @override
  String valueToString({
    required BuildContext context,
    required double? value,
  }) =>
      value?.toString() ?? FlutterCms.getCmsTexts(context).cmsAttributeValueNull;

  @override
  List<Object?> get props => [
        ...super.props,
        hint,
      ];
}
