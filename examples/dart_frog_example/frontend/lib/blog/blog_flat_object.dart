import 'package:flat/flat.dart';
import 'package:frontend/blog/use_cases/create_blog.dart';
import 'package:frontend/blog/use_cases/delete_blog.dart';
import 'package:frontend/blog/use_cases/load_blog_by_id.dart';
import 'package:frontend/blog/use_cases/load_blogs.dart';
import 'package:frontend/blog/use_cases/update_blog.dart';

FlatObjectStructure getBlogFlatObject(String role) => FlatObjectStructure(
      id: "blog",
      displayName: "Blog",
      canBeSortedById: false,
      attributes: [
        const FlatAttributeString(
          id: "title",
          displayName: "Title",
          hint: "Enter a title",
          invalidValueErrorMessage: "You have to enter a title",
          canObjectBeSortedByThisAttribute: true,
        ),
        const FlatAttributeHtml(
          id: "content",
          displayName: "Content",
          invalidValueErrorMessage: "You have to enter content",
        ),
        FlatAttributeDate(
          id: "day",
          displayName: "Day",
          defaultValue: DateTime.now(),
          canObjectBeSortedByThisAttribute: true,
        ),
        const FlatAttributeInt(
          id: "sortOrder",
          displayName: "Sort Order",
          invalidValueErrorMessage: "You have to enter a sort order number",
          defaultValue: 0,
          canObjectBeSortedByThisAttribute: true,
        ),
        const FlatAttributeColor(
          id: "color",
          displayName: "Color",
          invalidValueErrorMessage: "You have to select a color",
          isOptional: true,
        ),
        const FlatAttributeFile(
          id: "file",
          displayName: "File",
          isOptional: true,
        ),
      ],
      onCreateFlatObject: role == "admin" ? createBlog : null,
      onUpdateFlatObject: role == "admin" ? updateBlog : null,
      loadFlatObjectById: loadBlogById,
      onLoadFlatObjects: LoadFlatObjects.offset(loadBlogs),
      onDeleteFlatObject: role == "admin" ? deleteBlog : null,
    );
