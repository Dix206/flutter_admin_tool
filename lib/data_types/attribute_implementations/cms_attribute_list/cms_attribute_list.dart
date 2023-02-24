import 'package:flutter/widgets.dart';
import 'package:flutter_cms/data_types/attribute_implementations/cms_attribute_list/cms_attribute_list_widget.dart';

import 'package:flutter_cms/data_types/cms_attribute_structure.dart';
import 'package:flutter_cms/flutter_cms.dart';

class CmsAttributeList<T extends Object, S extends CmsAttributeStructure<T>> extends CmsAttributeStructure<List> {
  final CmsAttributeStructure<T> cmsAttributeStructure;

  const CmsAttributeList({
    required this.cmsAttributeStructure,
    required super.id,
    required super.displayName,
    super.defaultValue,
    super.invalidValueErrorMessage,
    super.isOptional = false,
    super.validator,
    super.canObjectBeSortedByThisAttribute = false,
    super.shouldBeDisplayedOnOverviewTable = true,
  });

  @override
  Widget buildWidget({
    required List? currentValue,
    required bool shouldDisplayValidationErrors,
    required OnCmsTypeUpdated<List<T>> onCmsTypeUpdated,
  }) {
    return CmsAttributeListWidget<T, S>(
      cmsTypeList: this,
      currentValue: currentValue?.cast() ?? [],
      shouldDisplayValidationErrors: shouldDisplayValidationErrors,
      onCmsTypeUpdated: onCmsTypeUpdated,
      cmsAttributeStructure: cmsAttributeStructure,
    );
  }

  @override
  String valueToString({
    required BuildContext context,
    required List? value,
  }) =>
      value == null
          ? FlutterCms.getCmsTexts(context).cmsAttributeValueNull
          : value
              .map(
                (item) => cmsAttributeStructure.valueToString(context: context, value: item),
              )
              .join(" | ");

  @override
  List<Object?> get props => [
        ...super.props,
        cmsAttributeStructure,
      ];
}
