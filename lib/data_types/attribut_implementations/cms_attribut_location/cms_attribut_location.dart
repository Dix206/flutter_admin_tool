import 'package:flutter/widgets.dart';
import 'package:flutter_cms/data_types/attribut_implementations/cms_attribut_location/cms_attribut_location_widget.dart';
import 'package:flutter_cms/data_types/attribut_implementations/cms_attribut_location/cms_location.dart';
import 'package:flutter_cms/data_types/cms_attribut_structure.dart';

class CmsAttributLocation extends CmsAttributStructure<CmsLocation> {
  final String latitudeHint;
  final String longitudeHint;

  const CmsAttributLocation({
    required super.id,
    required super.displayName,
    this.latitudeHint = "latitude",
    this.longitudeHint = "longitude",
    super.defaultValue,
    super.validator,
    super.invalidValueErrorMessage = "invalid input",
    super.isOptional = false,
    super.canObjectBeSortedByThisAttribut = false,
    super.shouldBeDisplayedOnOverviewTable = true,
  });

  @override
  Widget buildWidget({
    required BuildContext context,
    required CmsLocation? currentValue,
    required bool shouldDisplayValidationErrors,
    required OnCmsTypeUpdated<CmsLocation> onCmsTypeUpdated,
  }) =>
      CmsAttributLocationWidget(
        context: context,
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
      value == null ? "---" : "${value.latitude} | ${value.longitude}";

  @override
  List<Object?> get props => [
        ...super.props,
        latitudeHint,
        longitudeHint,
      ];
}
