import 'package:flutter/widgets.dart';
import 'package:flutter_cms/data_types/attribut_implementations/cms_attribut_selection/cms_attribut_selection_widget.dart';

import 'package:flutter_cms/data_types/cms_attribut_structure.dart';
import 'package:flutter_cms/flutter_cms.dart';

class CmsAttributSelection<T extends Object> extends CmsAttributStructure<T> {
  final List<T> options;

  /// Converts an option to a string that can be displayed to the user.
  final String Function(T) optionToString;

  const CmsAttributSelection({
    required this.options,
    required this.optionToString,
    required super.id,
    required super.displayName,
    super.defaultValue,
    super.invalidValueErrorMessage,
    super.isOptional = false,
    super.canObjectBeSortedByThisAttribut = false,
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
      CmsAttributSelectionWidget(
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
      value == null ? FlutterCms.getCmsTexts(context).cmsAttributValueNull : optionToString(value);

  @override
  List<Object?> get props => [
        ...super.props,
        options,
        optionToString,
      ];
}
