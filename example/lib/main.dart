import 'package:flutter/material.dart';
import 'package:flutter_cms/data_types/cms_attribut_int.dart';
import 'package:flutter_cms/data_types/cms_attribut_string.dart';
import 'package:flutter_cms/data_types/cms_attribut_value.dart';
import 'package:flutter_cms/data_types/cms_object.dart';
import 'package:flutter_cms/data_types/cms_object_value.dart';
import 'package:flutter_cms/data_types/result.dart';
import 'package:flutter_cms/ui/flutter_cms_widget.dart';

void main() {
  runApp(
    FlutterCms(
      cmsObjects: [
        authorCmsObject,
        booksCmsObject,
      ],
    ),
  );
}

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
];

final authorCmsObject = CmsObject(
  name: "Author",
  attributes: [
    CmsAttributString(
      name: "Name",
      validator: (name) {
        return name != null && name.length > 3;
      },
      errorMessage: "Name must be at least 3 characters long",
    ),
    CmsAttributInt(
      name: "Birthyear",
      validator: (year) => year != null && year > 1900 && year <= DateTime.now().year,
      errorMessage: "Please enter a valid year",
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
  }) =>
      Future.delayed(
        const Duration(seconds: 2),
        () => Result.success(
          const CmsObjectValueList(
            hasMoreItems: false,
            cmsObjectValues: autherCmsObjectValues,
          ),
        ),
      )),
);

const booksCmsObjectValues = [
  CmsObjectValue(
    id: 1,
    values: [
      CmsAttributValue(name: "Name", value: "John Doe"),
      CmsAttributValue(name: "Publisher", value: "Reclaim"),
    ],
  ),
  CmsObjectValue(
    id: 2,
    values: [
      CmsAttributValue(name: "Name", value: "Jane Doe"),
      CmsAttributValue(name: "Publisher", value: "Fred"),
    ],
  ),
];

final booksCmsObject = CmsObject(
  name: "Books",
  attributes: [
    CmsAttributString(
      name: "Name",
      validator: (name) => name != null && name.length > 3,
      errorMessage: "Name must be at least 3 characters long",
    ),
    CmsAttributString(
      name: "Publisher",
      validator: (verlag) => verlag != null && verlag.isNotEmpty,
      errorMessage: "Please enter a valid publisher",
    ),
  ],
  idToString: (id) => id.toString(),
  stringToId: (id) => int.parse(id),
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
