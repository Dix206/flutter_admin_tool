import 'package:flutter/widgets.dart';
import 'package:flutter_cms/data_types/attribut_implementations/cms_attribut_html/cms_attribut_html_widget.dart';

import 'package:flutter_cms/data_types/cms_attribut_structure.dart';
import 'package:flutter_cms/flutter_cms.dart';

class CmsAttributHtml extends CmsAttributStructure<String> {
  const CmsAttributHtml({
    required super.id,
    required super.displayName,
    super.defaultValue,
    super.validator,
    super.invalidValueErrorMessage,
    super.isOptional = false,
    super.canObjectBeSortedByThisAttribut = false,
    super.shouldBeDisplayedOnOverviewTable = true,
  });

  @override
  Widget buildWidget({
    required String? currentValue,
    required bool shouldDisplayValidationErrors,
    required OnCmsTypeUpdated<String> onCmsTypeUpdated,
  }) =>
      CmsAttributHtmlWidget(
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
      value ?? FlutterCms.getCmsTexts(context).cmsAttributValueNull;
}
