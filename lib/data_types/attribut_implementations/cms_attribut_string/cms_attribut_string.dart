import 'package:flutter/widgets.dart';

import 'package:flutter_cms/data_types/attribut_implementations/cms_attribut_string/cms_attribut_string_widget.dart';
import 'package:flutter_cms/data_types/cms_attribut_structure.dart';

class CmsAttributString extends CmsAttributStructure<String> {
  final String? hint;

  const CmsAttributString({
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
    required String? currentValue,
    required bool shouldDisplayValidationErrors,
    required OnCmsTypeUpdated<String> onCmsTypeUpdated,
  }) =>
      CmsAttributStringWidget(
        context: context,
        cmsTypeString: this,
        currentValue: currentValue,
        shouldDisplayValidationErrors: shouldDisplayValidationErrors,
        onCmsTypeUpdated: onCmsTypeUpdated,
      );

  @override
  String valueToString(String? value) => value ?? "---";

  @override
  List<Object?> get props => [
        displayName,
        isOptional,
        validator,
        invalidValueErrorMessage,
        hint,
      ];
}
