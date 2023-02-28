import 'package:equatable/equatable.dart';

import 'package:flat/data_types/flat_attribute_structure.dart';
import 'package:flat/data_types/flat_object_value.dart';
import 'package:flat/data_types/flat_result.dart';
import 'package:flat/data_types/load_flat_objects.dart';
import 'package:flat/extensions/iterable_extensions.dart';

typedef LoadFlatObjectById = Future<FlatResult<FlatObjectValue>> Function(String id);
typedef OnManipulateFlatObject = Future<FlatResult<Unit>> Function(FlatObjectValue);
typedef OnDeleteFlatObject = Future<FlatResult<Unit>> Function(String id);

/// This Class represents an object in the Flat-App. It should be used for every object which is stored in your backend.
/// The id of an FlatObject will always be a string. If your id isnt a string you have to convert it to a string while loading [FlatObjectValues] and load the id from a string while getting the id of a [FlatObjectValue].
class FlatObjectStructure extends Equatable {
  /// The id of an object structure will be used to identify the type of an object.
  /// It will also be used to navigate and will be visivle in the url.
  /// The id should be unique.
  final String id;

  /// The displayName of an object will be shown in the UI.
  final String displayName;

  final bool canBeSortedById;

  /// The attributes define the properties of an object.
  /// They are used to create and update objects.
  /// In the UI they will be displayed in the order they are defined.
  final List<FlatAttributeStructure> attributes;

  /// This method should return values of this flat object based on passed filters and pagination.
  /// If there are no more items to load, the [FlatOffsetObjectValueList.hasMoreItems] should be set to false.
  final LoadFlatObjects onLoadFlatObjects;

  /// This method will be called if an valid object should be created.
  /// If the creation failed it should return a [Result.error] with an error message which will be displayed to the user.
  /// If this method is not set, there will be no option to create a new instance of this object.
  final OnManipulateFlatObject? onCreateFlatObject;

  /// This method will be called if an existing object should be updated.
  /// If updating failed it should return a [Result.error] with an error message which will be displayed to the user.
  /// If this method is not set, there will be no option to update an existing instance of this object.
  final OnManipulateFlatObject? onUpdateFlatObject;

  /// This method will be called if an existing object should be delete.
  /// If the deletion failed it should return a [Result.error] with an error message which will be displayed to the user.
  /// If this method is not set, there will be no option to delete an existing instance of this object.
  final OnDeleteFlatObject? onDeleteFlatObject;

  /// This method will be called to load a single object by its id.
  /// If loading the object failed it should return a [Result.error] with an error message which will be displayed to the user.
  final LoadFlatObjectById loadFlatObjectById;

  FlatObjectStructure({
    required this.id,
    this.canBeSortedById = true,
    required this.displayName,
    required this.attributes,
    required this.onLoadFlatObjects,
    this.onCreateFlatObject,
    this.onUpdateFlatObject,
    this.onDeleteFlatObject,
    required this.loadFlatObjectById,
  }) : assert(
          attributes.every(
            (attribute) => attributes.every(
              (otherAttribute) => attribute.id != otherAttribute.id || attribute == otherAttribute,
            ),
          ),
          'There are two attributes with the same id in the flat object structure with id $id.',
        );

  FlatObjectValue toEmptyFlatObjectValue() {
    return FlatObjectValue(
      id: null,
      values: attributes
          .map(
            (flatValue) => flatValue.toEmptyAttributeValue(),
          )
          .toList(),
    );
  }

  /// Returns true if every attribute is valid.
  /// An attribute is valid if it is not required and null or if it is required and valid based on the attribute validator.
  bool isFlatObjectValueValid(FlatObjectValue flatObjectValue) {
    for (final attribute in attributes) {
      final attributeValue = flatObjectValue.getAttributeValueByAttributeId(attribute.id);

      if (!attribute.isValid(attributeValue)) {
        return false;
      }
    }

    return true;
  }

  FlatAttributeStructure? getAttributeById(String attributeId) => attributes.firstWhereOrNull(
        (attribute) => attribute.id.toLowerCase() == attributeId.toLowerCase(),
      );

  @override
  List<Object?> get props {
    return [
      id,
      displayName,
      canBeSortedById,
      attributes,
      onLoadFlatObjects,
      onCreateFlatObject,
      onUpdateFlatObject,
      onDeleteFlatObject,
      loadFlatObjectById,
    ];
  }

  @override
  bool get stringify => true;
}
