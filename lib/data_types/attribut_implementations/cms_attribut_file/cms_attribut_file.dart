import 'package:flutter/widgets.dart';
import 'package:flutter_cms/data_types/attribut_implementations/cms_attribut_file/cms_attribut_file_widget.dart';

import 'package:flutter_cms/data_types/cms_attribut_structure.dart';
import 'package:flutter_cms/data_types/cms_file_value.dart';
import 'package:flutter_cms/flutter_cms.dart';

class CmsAttributFile extends CmsAttributStructure<CmsFileValue> {
  /// Set this method to allow the user to download the romte file
  final Function(String fileUrl)? onFileDownload;

  const CmsAttributFile({
    required super.id,
    required super.displayName,
    this.onFileDownload,
    super.isOptional = false,
    super.invalidValueErrorMessage,
  }) : super(
          validator: null,
          defaultValue: null,
          shouldBeDisplayedOnOverviewTable: false,
          canObjectBeSortedByThisAttribut: false,
        );

  @override
  Widget buildWidget({
    required CmsFileValue? currentValue,
    required bool shouldDisplayValidationErrors,
    required OnCmsTypeUpdated<CmsFileValue> onCmsTypeUpdated,
  }) =>
      CmsAttributFileWidget(
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
      value?.url ?? FlutterCms.getCmsTexts(context).cmsAttributValueNull;

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
