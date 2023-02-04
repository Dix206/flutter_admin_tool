import 'package:flutter_cms/data_types/attribut_implementations/cms_attribut_int.dart';
import 'package:flutter_cms/data_types/attribut_implementations/cms_attribut_string.dart';
import 'package:flutter_cms/data_types/cms_attribut_value.dart';
import 'package:flutter_cms/data_types/cms_object.dart';
import 'package:flutter_cms/data_types/cms_object_value.dart';
import 'package:flutter_cms/data_types/result.dart';

const autherCmsObjectValues = [
  CmsObjectValue(
    id: 1,
    values: [
      CmsAttributValue(name: "Name", value: "John Doe"),
      CmsAttributValue(name: "Birthyear", value: 1990),
    ],
  ),
  CmsObjectValue(
    id: 2,
    values: [
      CmsAttributValue(name: "Name", value: "Jane Doe"),
      CmsAttributValue(name: "Birthyear", value: 1995),
    ],
  ),
  CmsObjectValue(
    id: 3,
    values: [
      CmsAttributValue(name: "Name", value: "Drei"),
      CmsAttributValue(name: "Birthyear", value: 1995),
    ],
  ),
  CmsObjectValue(
    id: 4,
    values: [
      CmsAttributValue(name: "Name", value: "Vier"),
      CmsAttributValue(name: "Birthyear", value: 1995),
    ],
  ),
  CmsObjectValue(
    id: 5,
    values: [
      CmsAttributValue(name: "Name", value: "Fuenf"),
      CmsAttributValue(name: "Birthyear", value: 1995),
    ],
  ),
];

final authorCmsObject = CmsObject(
  name: "Author",
  attributes: [
    CmsAttributString(
      name: "Name",
      validator: (name) {
        return name != null && name.length > 3;
      },
      invalidValueErrorMessage: "Name must be at least 3 characters long",
      canObjectBeSortedByThisAttribut: true,
    ),
    CmsAttributInt(
      name: "Birthyear",
      validator: (year) =>
          year != null && year > 1900 && year <= DateTime.now().year,
      invalidValueErrorMessage: "Please enter a valid year",
    ),
  ],
  idToString: (id) => id.toString(),
  stringToId: (id) => int.parse(id),
  onCreateCmsObject: (_) async {
    await Future.delayed(const Duration(seconds: 1));
    return Result.error("Das ging schief");
  },
  onUpdateCmsObject: (_) async {
    await Future.delayed(const Duration(seconds: 1));
    return Result.success(const Unit());
  },
  loadCmsObjectById: (id) async {
    await Future.delayed(const Duration(seconds: 1));
    for (var value in autherCmsObjectValues) {
      if (value.id == id) {
        return Result.success(value);
      }
    }

    return Result.error("Author not found");
  },
  onLoadCmsObjects: (({
    lastLoadedCmsObjectId,
    searchQuery,
    required sortOptions,
  }) =>
      Future.delayed(
        const Duration(seconds: 2),
        () => Result.success(
          const CmsObjectValueList(
            hasMoreItems: true,
            cmsObjectValues: autherCmsObjectValues,
          ),
        ),
      )),
);
