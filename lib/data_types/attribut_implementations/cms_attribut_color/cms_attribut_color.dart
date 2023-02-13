import 'package:flutter/widgets.dart';
import 'package:flutter_cms/data_types/attribut_implementations/cms_attribut_color/cms_attribut_color_widget.dart';
import 'package:flutter_cms/data_types/cms_attribut_structure.dart';

class CmsAttributColor extends CmsAttributStructure<Color> {
  const CmsAttributColor({
    required super.id,
    required super.displayName,
    super.defaultValue,
    super.isOptional = false,
    super.validator,
    super.invalidValueErrorMessage = "invalid color",
  }) : super(
          canObjectBeSortedByThisAttribut: false,
          shouldBeDisplayedOnOverviewTable: false,
        );

  @override
  Widget buildWidget({
    required BuildContext context,
    required Color? currentValue,
    required bool shouldDisplayValidationErrors,
    required OnCmsTypeUpdated<Color> onCmsTypeUpdated,
  }) =>
      CmsAttributColorWidget(
        title: displayName,
        currentValue: currentValue,
        onCmsTypeUpdated: onCmsTypeUpdated,
        cmsAttributColor: this,
        shouldDisplayValidationErrors: shouldDisplayValidationErrors,
      );

  @override
  String valueToString({
    required BuildContext context,
    required Color? value,
  }) =>
      value != null ? "#${value.value.toRadixString(16).padLeft(8, '0').toUpperCase()}" : "---";
}
