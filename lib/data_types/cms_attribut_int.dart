import 'package:flutter/widgets.dart';
import 'package:flutter_cms/ui/cms_attribut_widgets/cms_attribut_int_widget.dart';
import 'package:flutter_cms/data_types/cms_attribut.dart';

class CmsAttributInt extends CmsAttribut<int> {
  final String? hint;

  const CmsAttributInt({
    required String name,
    String? errorMessage,
    bool isOptional = false,
    Validator<int>? validator,
    this.hint,
  }) : super(
          name: name,
          invalidValueErrorMessage: errorMessage,
          isOptional: isOptional,
          validator: validator,
        );

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
  List<Object?> get props => [
        name,
        isOptional,
        validator,
        invalidValueErrorMessage,
        hint,
      ];
}
