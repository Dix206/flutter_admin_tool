import 'package:flutter/widgets.dart';
import 'package:flutter_cms/data_types/attribut_implementations/cms_attribut_bool/cms_attribut_bool_widget.dart';
import 'package:flutter_cms/data_types/cms_attribut_structure.dart';

class CmsAttributBool extends CmsAttributStructure<bool> {
  const CmsAttributBool({
    required super.id,
    required super.displayName,
    super.canObjectBeSortedByThisAttribut = false,
    super.shouldBeDisplayedOnOverviewTable = true,
  }) : super(
          isOptional: false,
          validator: null,
          invalidValueErrorMessage: "invalid input",
        );

  @override
  Widget buildWidget({
    required BuildContext context,
    required bool? currentValue,
    required bool shouldDisplayValidationErrors,
    required OnCmsTypeUpdated<bool> onCmsTypeUpdated,
  }) =>
      CmsAttributBoolWidget(
        title: displayName,
        currentValue: currentValue ?? false,
        onCmsTypeUpdated: onCmsTypeUpdated,
      );

  @override
  String valueToString({
    required BuildContext context,
    required bool? value,
  }) =>
      value?.toString() ?? "---";

  @override
  List<Object?> get props => [
        displayName,
        isOptional,
        validator,
        invalidValueErrorMessage,
      ];
}
