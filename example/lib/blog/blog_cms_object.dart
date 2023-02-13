import 'package:example/blog/use_cases/create_blog_use_case.dart';
import 'package:example/blog/use_cases/delete_blog_use_case.dart';
import 'package:example/blog/use_cases/load_blog_by_id.dart';
import 'package:example/blog/use_cases/load_blogs.dart';
import 'package:example/blog/use_cases/update_blog_use_case.dart';
import 'package:flutter_cms/data_types/attribut_implementations/cms_attribut_color/cms_attribut_color.dart';
import 'package:flutter_cms/data_types/attribut_implementations/cms_attribut_int/cms_attribut_int.dart';
import 'package:flutter_cms/data_types/attribut_implementations/cms_attribut_string/cms_attribut_string.dart';
import 'package:flutter_cms/data_types/attribut_implementations/cms_attribut_date/cms_attribut_date.dart';
import 'package:flutter_cms/data_types/cms_object_structure.dart';

final blogCmsObject = CmsObjectStructure(
  id: "blog",
  displayName: "Blog",
  canBeSortedById: false,
  attributes: [
    const CmsAttributString(
      id: "title",
      displayName: "Title",
      hint: "Enter a title",
      invalidValueErrorMessage: "You have to enter a title",
      canObjectBeSortedByThisAttribut: true,
    ),
    // TODO HTML
    const CmsAttributString(
      id: "content",
      displayName: "Content",
      hint: "Enter your content",
      invalidValueErrorMessage: "You have to enter content",
      isMultiline: true,
    ),
    CmsAttributDate(
      id: "day",
      displayName: "Day",
      defaultValue: DateTime.now(),
      canObjectBeSortedByThisAttribut: true,
    ),
    const CmsAttributInt(
      id: "sortOrder",
      displayName: "Sort Order",
      invalidValueErrorMessage: "You have to enter a sort order number",
      defaultValue: 0,
      canObjectBeSortedByThisAttribut: true,
    ),
    const CmsAttributColor(
      id: "color",
      displayName: "Color",
      invalidValueErrorMessage: "You have to select a color",
      isOptional: true,
    ),
  ],
  onCreateCmsObject: createBlog,
  onUpdateCmsObject: updateBlog,
  loadCmsObjectById: loadBlogById,
  onLoadCmsObjects: loadBlogs,
  onDeleteCmsObject: deleteBlog,
);