import 'package:flutter/widgets.dart';
import 'package:flutter_cms/ui/cms_attribut_widgets/cms_attribut_int_widget.dart';
import 'package:flutter_cms/data_types/cms_attribut_structure.dart';

class CmsAttributInt extends CmsAttributStructure<int> {
  final String? hint;

  const CmsAttributInt({
    this.hint,
    required super.id,
    required super.displayName,
    super.validator,
    super.invalidValueErrorMessage = "invalid input",
    super.isOptional = false,
    super.canObjectBeSortedByThisAttribut = false,
    super.shouldBeDisplayedOnOverviewTable = true,
  });

  @override
  Widget buildWidget({
    required BuildContext context,
    required int? currentValue,
    required bool shouldDisplayValidationErrors,
    required OnCmsTypeUpdated<int> onCmsTypeUpdated,
  }) =>
      CmsAttributIntWidget(
        context: context,
        cmsTypeInt: this,
        currentValue: currentValue,
        shouldDisplayValidationErrors: shouldDisplayValidationErrors,
        onCmsTypeUpdated: onCmsTypeUpdated,
      );

      @override
      String valueToString(int? value) => value?.toString() ?? "---";

  @override
  List<Object?> get props => [
        displayName,
        isOptional,
        validator,
        invalidValueErrorMessage,
        hint,
      ];
}
