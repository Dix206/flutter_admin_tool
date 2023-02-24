import 'package:example/article/article.dart';
import 'package:example/article/use_cases/create_article.dart';
import 'package:example/article/use_cases/delete_article.dart';
import 'package:example/article/use_cases/load_article_by_id.dart';
import 'package:example/article/use_cases/load_articles.dart';
import 'package:example/article/use_cases/load_authors.dart';
import 'package:example/article/use_cases/update_article.dart';
import 'package:flutter_cms/data_types/attribute_implementations/cms_attribute_string/cms_attribute_string.dart';
import 'package:flutter_cms/data_types/attribute_implementations/cms_attribute_image/cms_attribute_image.dart';
import 'package:flutter_cms/data_types/attribute_implementations/cms_attribute_bool/cms_attribute_bool.dart';
import 'package:flutter_cms/data_types/attribute_implementations/cms_attribute_date_time/cms_attribute_date_time.dart';
import 'package:flutter_cms/data_types/attribute_implementations/cms_attribute_reference/cms_attribute_reference.dart';
import 'package:flutter_cms/data_types/cms_object_structure.dart';

final articleCmsObject = CmsObjectStructure(
  id: "article",
  displayName: "Article",
  canBeSortedById: false,
  attributes: [
    const CmsAttributeString(
      id: "title",
      displayName: "Title",
      hint: "Enter a title",
      invalidValueErrorMessage: "You have to enter a title",
      canObjectBeSortedByThisAttribute: true,
    ),
    const CmsAttributeString(
      id: "description",
      displayName: "Description",
      hint: "Enter a description",
      invalidValueErrorMessage: "You have to enter a description",
      canObjectBeSortedByThisAttribute: false,
      isMultiline: true,
      maxLength: 24,
    ),
    const CmsAttributeImage(
      id: "image",
      displayName: "Image",
      isOptional: true,
    ),
    CmsAttributeDateTime(
      id: "timestamp",
      displayName: "Created at",
      canObjectBeSortedByThisAttribute: true,
      shouldBeDisplayedOnOverviewTable: true,
      invalidValueErrorMessage: "You have to enter a date time",
      minDateTime: DateTime(2020),
      maxDateTime: DateTime.now().add(const Duration(days: 365)),
    ),
    const CmsAttributeBool(
      id: "isActive",
      displayName: "Is Article active",
      canObjectBeSortedByThisAttribute: true,
      shouldBeDisplayedOnOverviewTable: true,
    ),
    CmsAttributeReference<Author>(
      id: "author",
      displayName: "Author",
      searchFunction: loadAuthors,
      getReferenceDisplayString: (author) => author.name,
      isOptional: true,
    ),
  ],
  onCreateCmsObject: createArticle,
  onUpdateCmsObject: updateArticle,
  loadCmsObjectById: loadArticleById,
  onLoadCmsObjects: loadArticles,
  onDeleteCmsObject: deleteArticle,
);
