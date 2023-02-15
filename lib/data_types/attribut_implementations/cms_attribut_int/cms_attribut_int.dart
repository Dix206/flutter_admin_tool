import 'package:flutter/widgets.dart';
import 'package:flutter_cms/data_types/attribut_implementations/cms_attribut_int/cms_attribut_int_widget.dart';
import 'package:flutter_cms/data_types/cms_attribut_structure.dart';
import 'package:flutter_cms/flutter_cms.dart';

class CmsAttributInt extends CmsAttributStructure<int> {
  final String? hint;

  const CmsAttributInt({
    this.hint,
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
    required int? currentValue,
    required bool shouldDisplayValidationErrors,
    required OnCmsTypeUpdated<int> onCmsTypeUpdated,
  }) =>
      CmsAttributIntWidget(
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
      value?.toString() ?? FlutterCms.getCmsTexts(context).cmsAttributValueNull;

  @override
  List<Object?> get props => [
        ...super.props,
        hint,
      ];
}
