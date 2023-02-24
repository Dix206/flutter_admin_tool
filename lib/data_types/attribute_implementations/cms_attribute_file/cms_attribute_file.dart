import 'package:flutter/widgets.dart';
import 'package:flutter_cms/data_types/attribute_implementations/cms_attribute_file/cms_attribute_file_widget.dart';

import 'package:flutter_cms/data_types/cms_attribute_structure.dart';
import 'package:flutter_cms/data_types/cms_file_value.dart';
import 'package:flutter_cms/flutter_cms.dart';

class CmsAttributeFile extends CmsAttributeStructure<CmsFileValue> {
  /// Set this method to allow the user to download the romte file
  final Function(String fileUrl)? onFileDownload;

  const CmsAttributeFile({
    required super.id,
    required super.displayName,
    this.onFileDownload,
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
      CmsAttributeFileWidget(
        cmsTypeFile: this,
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

  @override
  List<Object?> get props => [
        ...super.props,
        onFileDownload,
      ];
}
