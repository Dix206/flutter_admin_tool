import 'package:flutter/widgets.dart';

import 'package:flutter_cms/data_types/attribute_implementations/cms_attribute_image/cms_attribute_image_widget.dart';
import 'package:flutter_cms/data_types/cms_attribute_structure.dart';
import 'package:flutter_cms/data_types/cms_file_value.dart';
import 'package:flutter_cms/flutter_cms.dart';

class CmsAttributeImage extends CmsAttributeStructure<CmsFileValue> {
  const CmsAttributeImage({
    required super.id,
    required super.displayName,
    super.isOptional = false,
    super.invalidValueErrorMessage,
  }) : super(
          validator: null,
          defaultValue: null,
          shouldBeDisplayedOnOverviewTable: false,
          canObjectBeSortedByThisAttribute: false,
        );

  @override
  Widget buildWidget({
    required CmsFileValue? currentValue,
    required bool shouldDisplayValidationErrors,
    required OnCmsTypeUpdated<CmsFileValue> onCmsTypeUpdated,
  }) =>
      CmsAttributeImageWidget(
        cmsTypeImage: this,
        currentValue: currentValue,
        shouldDisplayValidationErrors: shouldDisplayValidationErrors,
        onCmsTypeUpdated: onCmsTypeUpdated,
      );

  @override
  String valueToString({
    required BuildContext context,
    required CmsFileValue? value,
  }) =>
      value?.url ?? FlutterCms.getCmsTexts(context).cmsAttributeValueNull;

  @override
  bool isValid(CmsFileValue? value) {
    return value?.data != null || (value?.url != null && value?.wasDeleted == false) || isOptional;
  }
}
