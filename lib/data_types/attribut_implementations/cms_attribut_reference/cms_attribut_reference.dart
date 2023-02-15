import 'package:flutter/widgets.dart';
import 'package:flutter_cms/data_types/attribut_implementations/cms_attribut_reference/cms_attribut_reference_widget.dart';

import 'package:flutter_cms/data_types/cms_attribut_structure.dart';
import 'package:flutter_cms/data_types/result.dart';

/// T is the type of the reference which will be setted
class CmsAttributReference<T extends Object> extends CmsAttributStructure<T> {
  final Future<Result<List<T>>> Function(String searchQuery) searchFunction;
  final String Function(T value) getReferenceDisplayString;

  const CmsAttributReference({
    required this.searchFunction,
    required this.getReferenceDisplayString,
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
    required T? currentValue,
    required bool shouldDisplayValidationErrors,
    required OnCmsTypeUpdated<T> onCmsTypeUpdated,
  }) =>
      CmsAttributReferenceWidget(
        cmsTypeReference: this,
        currentValue: currentValue,
        shouldDisplayValidationErrors: shouldDisplayValidationErrors,
        onCmsTypeUpdated: onCmsTypeUpdated,
      );

  @override
  String valueToString({
    required BuildContext context,
    required T? value,
  }) =>
      value == null ? "---" : getReferenceDisplayString(value);

  @override
  List<Object?> get props => [
        ...super.props,
        searchFunction,
        getReferenceDisplayString,
      ];
}
