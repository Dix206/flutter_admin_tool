import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter_cms/data_types/attribut_implementations/cms_attribut_image/cms_attribut_image_widget.dart';
import 'package:flutter_cms/data_types/cms_attribut_structure.dart';

class ImageValue extends Equatable {
  final Uint8List? imageData;
  final String? imageUrl;
  final Map<String, String>? headers;
  final bool wasDeleted;

  const ImageValue({
    required this.imageData,
    required this.imageUrl,
    required this.headers,
    required this.wasDeleted,
  });

  @override
  List<Object?> get props => [imageData, imageUrl, headers, wasDeleted];
}

class CmsAttributImage extends CmsAttributStructure<ImageValue> {
  const CmsAttributImage({
    required super.id,
    required super.displayName,
    super.isOptional = false,
  }) : super(
          validator: null,
          invalidValueErrorMessage: "invalid input",
          shouldBeDisplayedOnOverviewTable: false,
          canObjectBeSortedByThisAttribut: false,
        );

  @override
  Widget buildWidget({
    required BuildContext context,
    required ImageValue? currentValue,
    required bool shouldDisplayValidationErrors,
    required OnCmsTypeUpdated<ImageValue> onCmsTypeUpdated,
  }) =>
      CmsAttributImageWidget(
        context: context,
        cmsTypeString: this,
        currentValue: currentValue,
        shouldDisplayValidationErrors: shouldDisplayValidationErrors,
        onCmsTypeUpdated: onCmsTypeUpdated,
      );

  @override
  String valueToString({
    required BuildContext context,
    required ImageValue? value,
  }) =>
      value?.imageUrl ?? "---";

  @override
  bool isValid(ImageValue? value) {
    return (value?.imageData != null || value?.imageUrl != null && value?.wasDeleted == false) ||
        (value == null && isOptional);
  }
}
