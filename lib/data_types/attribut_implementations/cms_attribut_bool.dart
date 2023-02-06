import 'package:flutter/widgets.dart';
import 'package:flutter_cms/ui/cms_attribut_widgets/cms_attribut_bool_widget.dart';
import 'package:flutter_cms/data_types/cms_attribut.dart';

class CmsAttributBool extends CmsAttribut<bool> {
  const CmsAttributBool({
    required super.name,
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
        title: name,
        currentValue: currentValue ?? false,
        onCmsTypeUpdated: onCmsTypeUpdated,
      );

  @override
  String valueToString(bool? value) => value?.toString() ?? "---";

  @override
  List<Object?> get props => [
        name,
        isOptional,
        validator,
        invalidValueErrorMessage,
      ];
}
