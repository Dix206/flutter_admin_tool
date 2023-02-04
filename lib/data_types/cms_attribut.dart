import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_cms/data_types/cms_attribut_value.dart';

typedef Validator<T extends Object> = bool Function(T?);
typedef OnCmsTypeUpdated<T extends Object> = void Function(T?);
typedef ValueToString<T extends Object> = String Function(T?);

/// This class represents a single attribute of a [CmsObject].
/// [T] is the type of the value of this attribute.
abstract class CmsAttribut<T extends Object> extends Equatable {
  /// The name of an attribute will be shown in the CMS-UI.
  final String name;

  /// If this value is set to true, this value has to be setted in the CMS.
  /// If its false, this attribute can be null.
  final bool isOptional;

  /// The validator will validate if the user passed value is valid.
  /// If the validator is null, the attribute is always valid and every value of type [T] can be passed.
  final Validator<T>? validator;

  /// If the validation of this attribute failes (based on the passed [validator]) this message will be displayd to the user.
  final String invalidValueErrorMessage;

  /// If this value is true this attribut value will be displayed on the overview list. Otherwise the value will not be displayed.
  final bool shouldBeDisplayedOnOverviewTable;

  /// If this is set to true, the object list on the overview table can be sorted by this attribut.
  /// If the list can be sorted by this value, it is neccessary to implement the sort functionality in the object load function.
  final bool canObjectBeSortedByThisAttribut;

  const CmsAttribut({
    required this.name,
    required this.invalidValueErrorMessage,
    required this.isOptional,
    required this.validator,
    required this.shouldBeDisplayedOnOverviewTable,
    required this.canObjectBeSortedByThisAttribut,
  });

  Widget buildWidget({
    required BuildContext context,
    required T? currentValue,
    required bool shouldDisplayValidationErrors,
    required OnCmsTypeUpdated<T> onCmsTypeUpdated,
  });

  /// This function should return a readable string based on the passed value of this attribut.
  String valueToString(T? value);

  bool isValid(T? value) {
    return (isOptional || value != null) && (validator?.call(value) ?? true);
  }

  CmsAttributValue toEmptyAttributValue() {
    return CmsAttributValue<T>(
      name: name,
      value: null,
    );
  }

  @override
  bool? get stringify => true;

  @override
  List<Object?> get props => [
        name,
        isOptional,
        validator,
        invalidValueErrorMessage,
        valueToString,
        shouldBeDisplayedOnOverviewTable,
        canObjectBeSortedByThisAttribut,
      ];
}
