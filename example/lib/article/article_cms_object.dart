import 'package:example/article/article.dart';
import 'package:example/article/use_cases/create_article.dart';
import 'package:example/article/use_cases/delete_article.dart';
import 'package:example/article/use_cases/load_article_by_id.dart';
import 'package:example/article/use_cases/load_articles.dart';
import 'package:example/article/use_cases/load_authors.dart';
import 'package:example/article/use_cases/update_article.dart';
import 'package:flutter_cms/data_types/attribut_implementations/cms_attribut_string/cms_attribut_string.dart';
import 'package:flutter_cms/data_types/attribut_implementations/cms_attribut_image/cms_attribut_image.dart';
import 'package:flutter_cms/data_types/attribut_implementations/cms_attribut_bool/cms_attribut_bool.dart';
import 'package:flutter_cms/data_types/attribut_implementations/cms_attribut_date_time/cms_attribut_date_time.dart';
import 'package:flutter_cms/data_types/attribut_implementations/cms_attribut_reference/cms_attribut_reference.dart';
import 'package:flutter_cms/data_types/cms_object_structure.dart';

final articleCmsObject = CmsObjectStructure(
  id: "article",
  displayName: "Article",
  canBeSortedById: false,
  attributes: [
    const CmsAttributString(
      id: "title",
      displayName: "Title",
      hint: "Enter a title",
      invalidValueErrorMessage: "You have to enter a title",
      canObjectBeSortedByThisAttribut: true,
    ),
    const CmsAttributString(
      id: "description",
      hint: "Enter a description",
      displayName: "Description",
      invalidValueErrorMessage: "You have to enter a description",
      canObjectBeSortedByThisAttribut: false,
      isMultiline: true,
      maxLength: 24,
    ),
    const CmsAttributImage(
      id: "image",
      displayName: "Image",
      isOptional: true,
    ),
    CmsAttributDateTime(
      id: "timestamp",
      displayName: "Created at",
      canObjectBeSortedByThisAttribut: true,
      shouldBeDisplayedOnOverviewTable: true,
      invalidValueErrorMessage: "You have to enter a date time",
      minDateTime: DateTime(2020),
      maxDateTime: DateTime.now().add(const Duration(days: 365)),
    ),
    const CmsAttributBool(
      id: "isActive",
      displayName: "Is Article active",
      canObjectBeSortedByThisAttribut: true,
      shouldBeDisplayedOnOverviewTable: true,
    ),
    CmsAttributReference<Author>(
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
