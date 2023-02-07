import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter_cms/data_types/cms_attribut.dart';
import 'package:flutter_cms/ui/cms_attribut_widgets/cms_attribut_image_widget.dart';

class ImageValue extends Equatable {
  final Uint8List? imageData;
  final String? imageUrl;
  final Map<String, String>? headers;

  const ImageValue({
    required this.imageData,
    required this.imageUrl,
    required this.headers,
  });

  @override
  List<Object?> get props => [imageData, imageUrl];
}

class CmsAttributImage extends CmsAttribut<ImageValue> {
  const CmsAttributImage({
    required super.name,
    super.isOptional = false,
    super.canObjectBeSortedByThisAttribut = false,
    super.shouldBeDisplayedOnOverviewTable = true,
  }) : super(
          validator: null,
          invalidValueErrorMessage: "invalid input",
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
  String valueToString(ImageValue? value) => value?.imageUrl ?? "---";
}
