import 'package:flutter/widgets.dart';
import 'package:flutter_cms/data_types/attribut_implementations/cms_attribut_double/cms_attribut_double_widget.dart';
import 'package:flutter_cms/data_types/cms_attribut_structure.dart';

class CmsAttributDouble extends CmsAttributStructure<double> {
  final String? hint;

  const CmsAttributDouble({
    this.hint,
    required super.id,
    required super.displayName,
    super.defaultValue,
    super.validator,
    super.invalidValueErrorMessage = "invalid input",
    super.isOptional = false,
    super.canObjectBeSortedByThisAttribut = false,
    super.shouldBeDisplayedOnOverviewTable = true,
  });

  @override
  Widget buildWidget({
    required double? currentValue,
    required bool shouldDisplayValidationErrors,
    required OnCmsTypeUpdated<double> onCmsTypeUpdated,
  }) =>
      CmsAttributDoubleWidget(
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
      value?.toString() ?? "---";

  @override
  List<Object?> get props => [
        ...super.props,
        hint,
      ];
}
