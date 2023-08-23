import 'package:flutter/widgets.dart';
import 'package:flutter_admin_tool/data_types/attribute_implementations/flat_attribute_location/flat_attribute_location_widget.dart';
import 'package:flutter_admin_tool/data_types/attribute_implementations/flat_attribute_location/flat_location.dart';
import 'package:flutter_admin_tool/data_types/flat_attribute_structure.dart';
import 'package:flutter_admin_tool/flat_app.dart';

class FlatAttributeLocation extends FlatAttributeStructure<FlatLocation> {
  final String? latitudeHint;
  final String? longitudeHint;

  const FlatAttributeLocation({
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
    required FlatLocation? currentValue,
    required bool shouldDisplayValidationErrors,
    required OnFlatTypeUpdated<FlatLocation> onFlatTypeUpdated,
  }) =>
      FlatAttributeLocationWidget(
        flatTypeLocation: this,
        currentValue: currentValue,
        shouldDisplayValidationErrors: shouldDisplayValidationErrors,
        onFlatTypeUpdated: onFlatTypeUpdated,
      );

  @override
  String valueToString({
    required BuildContext context,
    required FlatLocation? value,
  }) =>
      value == null ? FlatApp.getFlatTexts(context).flatAttributeValueNull : "${value.latitude} | ${value.longitude}";

  @override
  List<Object?> get props => [
        ...super.props,
        latitudeHint,
        longitudeHint,
      ];
}
