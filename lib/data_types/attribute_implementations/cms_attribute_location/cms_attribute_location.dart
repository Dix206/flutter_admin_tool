import 'package:flutter/widgets.dart';
import 'package:flutter_cms/data_types/attribute_implementations/cms_attribute_location/cms_attribute_location_widget.dart';
import 'package:flutter_cms/data_types/attribute_implementations/cms_attribute_location/cms_location.dart';
import 'package:flutter_cms/data_types/cms_attribute_structure.dart';
import 'package:flutter_cms/flutter_cms.dart';

class CmsAttributeLocation extends CmsAttributeStructure<CmsLocation> {
  final String? latitudeHint;
  final String? longitudeHint;

  const CmsAttributeLocation({
    required super.id,
    required super.displayName,
    this.latitudeHint,
    this.longitudeHint,
    super.defaultValue,
    super.validator,
    super.invalidValueErrorMessage,
    super.isOptional = false,
    super.canObjectBeSortedByThisAttribute = false,
    super.shouldBeDisplayedOnOverviewTable = true,
  });

  @override
  Widget buildWidget({
    required CmsLocation? currentValue,
    required bool shouldDisplayValidationErrors,
    required OnCmsTypeUpdated<CmsLocation> onCmsTypeUpdated,
  }) =>
      CmsAttributeLocationWidget(
        cmsTypeLocation: this,
        currentValue: currentValue,
        shouldDisplayValidationErrors: shouldDisplayValidationErrors,
        onCmsTypeUpdated: onCmsTypeUpdated,
      );

  @override
  String valueToString({
    required BuildContext context,
    required CmsLocation? value,
  }) =>
      value == null ? FlutterCms.getCmsTexts(context).cmsAttributeValueNull : "${value.latitude} | ${value.longitude}";

  @override
  List<Object?> get props => [
        ...super.props,
        latitudeHint,
        longitudeHint,
      ];
}
