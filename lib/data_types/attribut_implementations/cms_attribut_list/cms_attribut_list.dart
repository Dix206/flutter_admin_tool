import 'package:flutter/widgets.dart';
import 'package:flutter_cms/data_types/attribut_implementations/cms_attribut_list/cms_attribut_list_widget.dart';

import 'package:flutter_cms/data_types/cms_attribut_structure.dart';

class CmsAttributList<T extends Object, S extends CmsAttributStructure<T>> extends CmsAttributStructure<List> {
  final CmsAttributStructure<T> cmsAttributStructure;

  const CmsAttributList({
    required this.cmsAttributStructure,
    required super.id,
    required super.displayName,
    super.defaultValue,
    super.invalidValueErrorMessage = "invalid input",
    super.isOptional = false,
    super.validator,
    super.canObjectBeSortedByThisAttribut = false,
    super.shouldBeDisplayedOnOverviewTable = true,
  });

  @override
  Widget buildWidget({
    required List? currentValue,
    required bool shouldDisplayValidationErrors,
    required OnCmsTypeUpdated<List<T>> onCmsTypeUpdated,
  }) {
    return CmsAttributListWidget<T, S>(
      cmsTypeList: this,
      currentValue: currentValue?.cast() ?? [],
      shouldDisplayValidationErrors: shouldDisplayValidationErrors,
      onCmsTypeUpdated: onCmsTypeUpdated,
      cmsAttributStructure: cmsAttributStructure,
    );
  }

  @override
  String valueToString({
    required BuildContext context,
    required List? value,
  }) =>
      value == null
          ? "---"
          : value
              .map(
                (item) => cmsAttributStructure.valueToString(context: context, value: item),
              )
              .join(" | ");

  @override
  List<Object?> get props => [
        ...super.props,
        cmsAttributStructure,
      ];
}
