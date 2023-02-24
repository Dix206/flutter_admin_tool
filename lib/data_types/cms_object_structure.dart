import 'package:equatable/equatable.dart';

import 'package:flutter_cms/data_types/cms_attribute_structure.dart';
import 'package:flutter_cms/data_types/cms_object_sort_options.dart';
import 'package:flutter_cms/data_types/cms_object_value.dart';
import 'package:flutter_cms/data_types/cms_result.dart';
import 'package:flutter_cms/extensions/iterable_extensions.dart';

typedef LoadCmsObjectById = Future<CmsResult<CmsObjectValue>> Function(String id);
typedef OnManipulateCmsObject = Future<CmsResult<Unit>> Function(CmsObjectValue);
typedef OnDeleteCmsObject = Future<CmsResult<Unit>> Function(String id);
typedef OnLoadCmsObjects = Future<CmsResult<CmsObjectValueList>> Function({
  required int page,
  required String? searchQuery,
  required CmsObjectSortOptions? sortOptions,
});

/// This Class represents an object in the CMS. It should be used for every object which is stored in your backend.
/// The id of an CMSObject will always be a string. If your id isnt a string you have to convert it to a string while loading [CmsObjectValues] and load the id from a string while getting the id of a [CmsObjectValue].
class CmsObjectStructure extends Equatable {
  /// The id of an object structure will be used to identify the type of an object.
  /// It will also be used to navigate and will be visivle in the url.
  /// The id should be unique.
  final String id;

  /// The displayName of an object will be shown in the CMS-UI.
  final String displayName;

  final bool canBeSortedById;

  /// The attributes define the properties of an object.
  /// They are used to create and update objects.
  /// In the UI they will be displayed in the order they are defined.
  final List<CmsAttributeStructure> attributes;

  /// This method should return values of this cms object based on passed filters and pagination.
  /// If there are no more items to load, the [CmsObjectValueList.hasMoreItems] should be set to false.
  final OnLoadCmsObjects onLoadCmsObjects;

  /// This method will be called if an valid object should be created.
  /// If the creation failed it should return a [Result.error] with an error message which will be displayed to the user.
  /// If this method is not set, there will be no option to create a new instance of this object.
  final OnManipulateCmsObject? onCreateCmsObject;

  /// This method will be called if an existing object should be updated.
  /// If updating failed it should return a [Result.error] with an error message which will be displayed to the user.
  /// If this method is not set, there will be no option to update an existing instance of this object.
  final OnManipulateCmsObject? onUpdateCmsObject;

  /// This method will be called if an existing object should be delete.
  /// If the deletion failed it should return a [Result.error] with an error message which will be displayed to the user.
  /// If this method is not set, there will be no option to delete an existing instance of this object.
  final OnDeleteCmsObject? onDeleteCmsObject;

  /// This method will be called to load a single object by its id.
  /// If loading the object failed it should return a [Result.error] with an error message which will be displayed to the user.
  final LoadCmsObjectById loadCmsObjectById;

  CmsObjectStructure({
    required this.id,
    this.canBeSortedById = true,
    required this.displayName,
    required this.attributes,
    required this.onLoadCmsObjects,
    this.onCreateCmsObject,
    this.onUpdateCmsObject,
    this.onDeleteCmsObject,
    required this.loadCmsObjectById,
  }) : assert(
          attributes.every(
            (attribute) => attributes.every(
              (otherAttribute) => attribute.id != otherAttribute.id || attribute == otherAttribute,
            ),
          ),
          'There are two attributes with the same id in the cms object structure with id $id.',
        );

  CmsObjectValue toEmptyCmsObjectValue() {
    return CmsObjectValue(
      id: null,
      values: attributes
          .map(
            (cmsValue) => cmsValue.toEmptyAttributeValue(),
          )
          .toList(),
    );
  }

  /// Returns true if every attribute is valid.
  /// An attribute is valid if it is not required and null or if it is required and valid based on the attribute validator.
  bool isCmsObjectValueValid(CmsObjectValue cmsObjectValue) {
    for (final attribute in attributes) {
      final attributeValue = cmsObjectValue.getAttributeValueByAttributeId(attribute.id);

      if (!attribute.isValid(attributeValue)) {
        return false;
      }
    }

    return true;
  }

  CmsAttributeStructure? getAttributeById(String attributeId) => attributes.firstWhereOrNull(
        (attribute) => attribute.id.toLowerCase() == attributeId.toLowerCase(),
      );

  @override
  List<Object?> get props {
    return [
      id,
      displayName,
      canBeSortedById,
      attributes,
      onLoadCmsObjects,
      onCreateCmsObject,
      onUpdateCmsObject,
      onDeleteCmsObject,
      loadCmsObjectById,
    ];
  }

  @override
  bool get stringify => true;
}
