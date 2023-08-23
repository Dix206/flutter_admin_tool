import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_admin_tool/data_types/flat_attribute_value.dart';

typedef Validator<T extends Object> = bool Function(T?);
typedef OnFlatTypeUpdated<T extends Object> = void Function(T?);
typedef ValueToString<T extends Object> = String Function(T?);

/// This class represents the structure of a single attribute of a [FlatObjectStructure].
/// [T] is the type of the value of this attribute.
abstract class FlatAttributeStructure<T extends Object> extends Equatable {
  /// This id will be used to identify a specific FlatAttribute of an FlatObject. The id has to be unique per FlatObject.
  final String id;

  /// The name of an attribute will be shown in the UI.
  final String displayName;

  /// If this value is set to false, this value has to be setted while creating/updating this object.
  /// If its true, this attribute can be null.
  final bool isOptional;

  /// The validator will validate if the user passed value is valid.
  /// If the validator is null, the attribute is always valid and every value of type [T] can be passed.
  final Validator<T>? validator;

  /// If the validation of this attribute failes (based on the passed [validator]) this message will be displayd to the user.
  final String? invalidValueErrorMessage;

  /// If this value is true this attribute value will be displayed on the overview list. Otherwise the value will not be displayed.
  final bool shouldBeDisplayedOnOverviewTable;

  /// If this is set to true, the object list on the overview table can be sorted by this attribute.
  /// If the list can be sorted by this value, it is neccessary to implement the sort functionality in the object load function.
  final bool canObjectBeSortedByThisAttribute;

  // This value will be initially used while creating a new object.
  final T? defaultValue;

  const FlatAttributeStructure({
    required this.id,
    required this.displayName,
    required this.invalidValueErrorMessage,
    required this.isOptional,
    required this.validator,
    required this.shouldBeDisplayedOnOverviewTable,
    required this.canObjectBeSortedByThisAttribute,
    required this.defaultValue,
  });

  Widget buildWidget({
    required T? currentValue,
    required bool shouldDisplayValidationErrors,
    required OnFlatTypeUpdated<T> onFlatTypeUpdated,
  });

  /// This function should return a readable string based on the passed value of this attribute.
  String valueToString({
   required BuildContext context,
   required T? value,
  });

  bool isValid(T? value) {
    return (value != null && (validator?.call(value) ?? true)) || (value == null && isOptional);
  }

  FlatAttributeValue toEmptyAttributeValue() {
    return FlatAttributeValue<T>(
      id: id,
      value: defaultValue,
    );
  }

  @override
  bool? get stringify => true;

  @override
  List<Object?> get props => [
        id,
        displayName,
        isOptional,
        validator,
        invalidValueErrorMessage,
        valueToString,
        shouldBeDisplayedOnOverviewTable,
        canObjectBeSortedByThisAttribute,
        defaultValue,
      ];
}
