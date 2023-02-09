
import 'package:flutter_cms/data_types/attribut_implementations/cms_attribut_string/cms_attribut_string.dart';
import 'package:flutter_cms/data_types/cms_attribut_value.dart';
import 'package:flutter_cms/data_types/cms_object_structure.dart';
import 'package:flutter_cms/data_types/cms_object_value.dart';
import 'package:flutter_cms/data_types/result.dart';

const booksCmsObjectValues = [
  CmsObjectValue(
    id: "1",
    values: [
      CmsAttributValue(id: "Name", value: "John Doe"),
      CmsAttributValue(id: "Publisher", value: "Reclaim"),
    ],
  ),
  CmsObjectValue(
    id: "2",
    values: [
      CmsAttributValue(id: "Name", value: "Jane Doe"),
      CmsAttributValue(id: "Publisher", value: "Fred"),
    ],
  ),
];

final booksCmsObject = CmsObjectStructure(
  id: "books",
  displayName: "Books",
  attributes: [
    CmsAttributString(
      id: "Name",
      displayName: "Name",
      validator: (name) => name != null && name.length > 3,
      invalidValueErrorMessage: "Name must be at least 3 characters long",
    ),
    CmsAttributString(
      id: "Publisher",
      displayName: "Publisher",
      validator: (verlag) => verlag != null && verlag.isNotEmpty,
      invalidValueErrorMessage: "Please enter a valid publisher",
    ),
  ],
  loadCmsObjectById: (id) async {
    await Future.delayed(const Duration(seconds: 1));
    for (var value in booksCmsObjectValues) {
      if (value.id == id) {
        return Result.success(value);
      }
    }

    return Result.error("Book not found");
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
            hasMoreItems: false,
            cmsObjectValues: booksCmsObjectValues,
          ),
        ),
      )),
);
