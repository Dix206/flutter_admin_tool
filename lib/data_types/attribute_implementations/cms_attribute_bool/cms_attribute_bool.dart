import 'package:flutter/widgets.dart';
import 'package:flutter_cms/data_types/attribute_implementations/cms_attribute_bool/cms_attribute_bool_widget.dart';
import 'package:flutter_cms/data_types/cms_attribute_structure.dart';
import 'package:flutter_cms/flutter_cms.dart';

class CmsAttributeBool extends CmsAttributeStructure<bool> {
  const CmsAttributeBool({
    required super.id,
    required super.displayName,
    super.defaultValue = false,
    super.canObjectBeSortedByThisAttribute = false,
    super.shouldBeDisplayedOnOverviewTable = true,
  }) : super(
          isOptional: false,
          validator: null,
          invalidValueErrorMessage: null,
        );

  @override
  Widget buildWidget({
    required bool? currentValue,
    required bool shouldDisplayValidationErrors,
    required OnCmsTypeUpdated<bool> onCmsTypeUpdated,
  }) =>
      CmsAttributeBoolWidget(
        title: displayName,
        currentValue: currentValue ?? false,
        onCmsTypeUpdated: onCmsTypeUpdated,
      );

  @override
  String valueToString({
    required BuildContext context,
    required bool? value,
  }) =>
      value?.toString() ?? FlutterCms.getCmsTexts(context).cmsAttributeValueNull;
}
