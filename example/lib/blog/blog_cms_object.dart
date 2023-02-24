import 'package:appwrite/models.dart';
import 'package:example/blog/use_cases/create_blog.dart';
import 'package:example/blog/use_cases/delete_blog.dart';
import 'package:example/blog/use_cases/load_blog_by_id.dart';
import 'package:example/blog/use_cases/load_blogs.dart';
import 'package:example/blog/use_cases/update_blog.dart';
import 'package:flutter_cms/data_types/attribute_implementations/cms_attribute_color/cms_attribute_color.dart';
import 'package:flutter_cms/data_types/attribute_implementations/cms_attribute_file/cms_attribute_file.dart';
import 'package:flutter_cms/data_types/attribute_implementations/cms_attribute_html/cms_attribute_html.dart';
import 'package:flutter_cms/data_types/attribute_implementations/cms_attribute_int/cms_attribute_int.dart';
import 'package:flutter_cms/data_types/attribute_implementations/cms_attribute_string/cms_attribute_string.dart';
import 'package:flutter_cms/data_types/attribute_implementations/cms_attribute_date/cms_attribute_date.dart';
import 'package:flutter_cms/data_types/cms_object_structure.dart';

CmsObjectStructure getBlogCmsObject(Account account) => CmsObjectStructure(
      id: "blog",
      displayName: "Blog",
      canBeSortedById: false,
      attributes: [
        const CmsAttributeString(
          id: "title",
          displayName: "Title",
          hint: "Enter a title",
          invalidValueErrorMessage: "You have to enter a title",
          canObjectBeSortedByThisAttribute: true,
        ),
        const CmsAttributeHtml(
          id: "content",
          displayName: "Content",
          invalidValueErrorMessage: "You have to enter content",
        ),
        CmsAttributeDate(
          id: "day",
          displayName: "Day",
          defaultValue: DateTime.now(),
          canObjectBeSortedByThisAttribute: true,
        ),
        const CmsAttributeInt(
          id: "sortOrder",
          displayName: "Sort Order",
          invalidValueErrorMessage: "You have to enter a sort order number",
          defaultValue: 0,
          canObjectBeSortedByThisAttribute: true,
        ),
        const CmsAttributeColor(
          id: "color",
          displayName: "Color",
          invalidValueErrorMessage: "You have to select a color",
          isOptional: true,
        ),
        const CmsAttributeFile(
          id: "file",
          displayName: "File",
          isOptional: true,
        ),
      ],
      onCreateCmsObject: account.prefs.data["role"] == "admin" ? createBlog : null,
      onUpdateCmsObject: account.prefs.data["role"] == "admin" ? updateBlog : null,
      loadCmsObjectById: loadBlogById,
      onLoadCmsObjects: loadBlogs,
      onDeleteCmsObject: account.prefs.data["role"] == "admin" ? deleteBlog : null,
    );
