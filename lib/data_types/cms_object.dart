import 'package:equatable/equatable.dart';

import 'package:flutter_cms/data_types/cms_attribut.dart';
import 'package:flutter_cms/data_types/cms_object_sort_options.dart';
import 'package:flutter_cms/data_types/cms_object_value.dart';
import 'package:flutter_cms/data_types/result.dart';
import 'package:flutter_cms/extensions/iterable_extensions.dart';

typedef IdToString = String Function(Object);
typedef StringToId = Object? Function(String);
typedef LoadCmsObjectById = Future<Result<CmsObjectValue>> Function(Object);
typedef OnManipulateCmsObject = Future<Result<Unit>> Function(CmsObjectValue);
typedef OnLoadCmsObjects = Future<Result<CmsObjectValueList>> Function({
  required Object? lastLoadedCmsObjectId,
  required String? searchQuery,
  required CmsObjectSortOptions sortOptions,
});

/// This Class represents an object in the CMS. It should be used for every object which is stored in your backend.
class CmsObject extends Equatable {
  /// The name of an object will be shown in the CMS-UI.
  /// The name should be unique.
  final String name;

  /// The attributes define the properties of an object.
  /// They are used to create and update objects.
  /// In the UI they will be displayed in the order they are defined.
  final List<CmsAttribut> attributes;

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
  final OnManipulateCmsObject? onDeleteCmsObject;

  /// This method will be called to load a single object by its id.
  /// If loading the object failed it should return a [Result.error] with an error message which will be displayed to the user.
  final LoadCmsObjectById loadCmsObjectById;

  /// This method should return a string representation of the passed id.
  final IdToString idToString;

  /// This method should return an id based on the passed string. The passed string will have the format from the result of [idToString].
  final StringToId stringToId;

  const CmsObject({
    required this.name,
    required this.attributes,
    required this.onLoadCmsObjects,
    this.onCreateCmsObject,
    this.onUpdateCmsObject,
    this.onDeleteCmsObject,
    required this.loadCmsObjectById,
    required this.idToString,
    required this.stringToId,
  });

  CmsObjectValue toEmptyCmsObjectValue() {
    return CmsObjectValue(
      id: 2,
      values: attributes
          .map(
            (cmsValue) => cmsValue.toEmptyAttributValue(),
          )
          .toList(),
    );
  }

  /// Returns true if every attribute is valid.
  /// An attribute is valid if it is not required and null or if it is required and valid based on the attribut validator.
  bool isCmsObjectValueValid(CmsObjectValue cmsObjectValue) {
    for (final attribute in attributes) {
      final attributValue =
          cmsObjectValue.getAttributeValueByName(attribute.name)?.value;

      if (!attribute.isValid(attributValue)) {
        return false;
      }
    }

    return true;
  }

  CmsAttribut? getAttributByName(String attributName) =>
      attributes.firstWhereOrNull((attribut) => attribut.name.toLowerCase() == attributName.toLowerCase());

  @override
  List<Object?> get props {
    return [
      name,
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
