import 'package:flutter/widgets.dart';
import 'package:flutter_cms/data_types/attribute_implementations/cms_attribute_int/cms_attribute_int_widget.dart';
import 'package:flutter_cms/data_types/cms_attribute_structure.dart';
import 'package:flutter_cms/flutter_cms.dart';

class CmsAttributeInt extends CmsAttributeStructure<int> {
  final String? hint;

  const CmsAttributeInt({
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
    required int? currentValue,
    required bool shouldDisplayValidationErrors,
    required OnCmsTypeUpdated<int> onCmsTypeUpdated,
  }) =>
      CmsAttributeIntWidget(
        cmsTypeInt: this,
        currentValue: currentValue,
        shouldDisplayValidationErrors: shouldDisplayValidationErrors,
        onCmsTypeUpdated: onCmsTypeUpdated,
      );

  @override
  String valueToString({
    required BuildContext context,
    required int? value,
  }) =>
      value?.toString() ?? FlutterCms.getCmsTexts(context).cmsAttributeValueNull;

  @override
  List<Object?> get props => [
        ...super.props,
        hint,
      ];
}
