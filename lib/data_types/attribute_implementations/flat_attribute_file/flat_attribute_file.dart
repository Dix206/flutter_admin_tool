import 'package:flutter/widgets.dart';
import 'package:flutter_admin_tool/data_types/attribute_implementations/flat_attribute_file/flat_attribute_file_widget.dart';

import 'package:flutter_admin_tool/data_types/flat_attribute_structure.dart';
import 'package:flutter_admin_tool/data_types/flat_file_value.dart';
import 'package:flutter_admin_tool/flat_app.dart';

class FlatAttributeFile extends FlatAttributeStructure<FlatFileValue> {
  /// Set this method to allow the user to download the romte file
  final Function(String fileUrl)? onFileDownload;

  const FlatAttributeFile({
    required super.id,
    required super.displayName,
    this.onFileDownload,
    super.isOptional = false,
    super.canBeEdited = true,
    super.invalidValueErrorMessage,
  }) : super(
          validator: null,
          defaultValue: null,
          shouldBeDisplayedOnOverviewTable: false,
          canObjectBeSortedByThisAttribute: false,
        );

  @override
  Widget buildWidget({
    required FlatFileValue? currentValue,
    required bool shouldDisplayValidationErrors,
    required OnFlatTypeUpdated<FlatFileValue> onFlatTypeUpdated,
  }) =>
      FlatAttributeFileWidget(
        flatTypeFile: this,
        currentValue: currentValue,
        shouldDisplayValidationErrors: shouldDisplayValidationErrors,
        onFlatTypeUpdated: onFlatTypeUpdated,
      );

  @override
  String valueToString({
    required BuildContext context,
    required FlatFileValue? value,
  }) =>
      value?.url ?? FlatApp.getFlatTexts(context).flatAttributeValueNull;

  @override
  bool isValid(FlatFileValue? value) {
    return value?.data != null ||
        (value?.url != null && value?.wasDeleted == false) ||
        isOptional;
  }

  @override
  List<Object?> get props => [
        ...super.props,
        onFileDownload,
      ];
}
