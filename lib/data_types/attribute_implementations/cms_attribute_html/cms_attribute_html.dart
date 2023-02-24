import 'package:flutter/widgets.dart';
import 'package:flutter_cms/data_types/attribute_implementations/cms_attribute_html/cms_attribute_html_widget.dart';

import 'package:flutter_cms/data_types/cms_attribute_structure.dart';
import 'package:flutter_cms/flutter_cms.dart';

class CmsAttributeHtml extends CmsAttributeStructure<String> {
  const CmsAttributeHtml({
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
    required String? currentValue,
    required bool shouldDisplayValidationErrors,
    required OnCmsTypeUpdated<String> onCmsTypeUpdated,
  }) =>
      CmsAttributeHtmlWidget(
        cmsTypeHtml: this,
        currentValue: currentValue,
        shouldDisplayValidationErrors: shouldDisplayValidationErrors,
        onCmsTypeUpdated: onCmsTypeUpdated,
      );

  @override
  bool isValid(String? value) {
    return (value?.trim().isNotEmpty == true && (validator?.call(value) ?? true)) ||
        (value?.trim().isNotEmpty != false && isOptional);
  }

  @override
  String valueToString({
    required BuildContext context,
    required String? value,
  }) =>
      value ?? FlutterCms.getCmsTexts(context).cmsAttributeValueNull;
}
