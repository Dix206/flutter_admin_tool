import 'package:flutter/widgets.dart';

import 'package:flutter_cms/ui/cms_attribut_widgets/cms_attribut_string_widget.dart';
import 'package:flutter_cms/data_types/cms_attribut.dart';

class CmsAttributString extends CmsAttribut<String> {
  final String? hint;
  
  const CmsAttributString({
    required String name,
    this.hint,
    String? errorMessage,
    bool isOptional = false,
    Validator<String>? validator,
  }) : super(
          name: name,
          invalidValueErrorMessage: errorMessage,
          isOptional: isOptional,
          validator: validator,
        );

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
  List<Object?> get props => [
        name,
        isOptional,
        validator,
        invalidValueErrorMessage,
        hint,
      ];
}
