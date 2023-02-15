import 'package:flutter/widgets.dart';

import 'package:flutter_cms/data_types/attribut_implementations/cms_attribut_string/cms_attribut_string_widget.dart';
import 'package:flutter_cms/data_types/cms_attribut_structure.dart';
import 'package:flutter_cms/flutter_cms.dart';

class CmsAttributString extends CmsAttributStructure<String> {
  final String? hint;
  final bool isMultiline;
  final int? maxLength;

  const CmsAttributString({
    this.hint,
    required super.id,
    required super.displayName,
    super.defaultValue,
    this.isMultiline = false,
    this.maxLength,
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
      CmsAttributStringWidget(
        cmsTypeString: this,
        currentValue: currentValue,
        shouldDisplayValidationErrors: shouldDisplayValidationErrors,
        onCmsTypeUpdated: onCmsTypeUpdated,
        maxLength: maxLength,
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

  @override
  List<Object?> get props => [
        ...super.props,
        hint,
        isMultiline,
        maxLength,
      ];
}
