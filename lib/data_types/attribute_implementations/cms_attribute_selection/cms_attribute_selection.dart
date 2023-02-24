import 'package:flutter/widgets.dart';
import 'package:flutter_cms/data_types/attribute_implementations/cms_attribute_selection/cms_attribute_selection_widget.dart';

import 'package:flutter_cms/data_types/cms_attribute_structure.dart';
import 'package:flutter_cms/flutter_cms.dart';

class CmsAttributeSelection<T extends Object> extends CmsAttributeStructure<T> {
  final List<T> options;

  /// Converts an option to a string that can be displayed to the user.
  final String Function(T) optionToString;

  const CmsAttributeSelection({
    required this.options,
    required this.optionToString,
    required super.id,
    required super.displayName,
    super.defaultValue,
    super.invalidValueErrorMessage,
    super.isOptional = false,
    super.canObjectBeSortedByThisAttribute = false,
    super.shouldBeDisplayedOnOverviewTable = true,
  }) : super(
          validator: null,
        );

  @override
  Widget buildWidget({
    required T? currentValue,
    required bool shouldDisplayValidationErrors,
    required OnCmsTypeUpdated<T> onCmsTypeUpdated,
  }) =>
      CmsAttributeSelectionWidget(
        cmsTypeSelection: this,
        currentValue: currentValue,
        shouldDisplayValidationErrors: shouldDisplayValidationErrors,
        onCmsTypeUpdated: onCmsTypeUpdated,
        options: options,
      );

  @override
  String valueToString({
    required BuildContext context,
    required T? value,
  }) =>
      value == null ? FlutterCms.getCmsTexts(context).cmsAttributeValueNull : optionToString(value);

  @override
  List<Object?> get props => [
        ...super.props,
        options,
        optionToString,
      ];
}
