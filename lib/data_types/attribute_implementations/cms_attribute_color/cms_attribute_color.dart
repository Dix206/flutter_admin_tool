import 'package:flutter/widgets.dart';
import 'package:flutter_cms/data_types/attribute_implementations/cms_attribute_color/cms_attribute_color_widget.dart';
import 'package:flutter_cms/data_types/cms_attribute_structure.dart';
import 'package:flutter_cms/flutter_cms.dart';

class CmsAttributeColor extends CmsAttributeStructure<Color> {
  const CmsAttributeColor({
    required super.id,
    required super.displayName,
    super.defaultValue,
    super.isOptional = false,
    super.validator,
    super.invalidValueErrorMessage,
  }) : super(
          canObjectBeSortedByThisAttribute: false,
          shouldBeDisplayedOnOverviewTable: false,
        );

  @override
  Widget buildWidget({
    required Color? currentValue,
    required bool shouldDisplayValidationErrors,
    required OnCmsTypeUpdated<Color> onCmsTypeUpdated,
  }) =>
      CmsAttributeColorWidget(
        title: displayName,
        currentValue: currentValue,
        onCmsTypeUpdated: onCmsTypeUpdated,
        cmsAttributeColor: this,
        shouldDisplayValidationErrors: shouldDisplayValidationErrors,
      );

  @override
  String valueToString({
    required BuildContext context,
    required Color? value,
  }) =>
      value != null ? "#${value.value.toRadixString(16).padLeft(8, '0').toUpperCase()}" : FlutterCms.getCmsTexts(context).cmsAttributeValueNull;
}
