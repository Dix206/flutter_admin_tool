import 'package:example/article/use_cases/create_article_use_case.dart';
import 'package:example/article/use_cases/delete_article_use_case.dart';
import 'package:example/article/use_cases/load_article_by_id.dart';
import 'package:example/article/use_cases/load_articles.dart';
import 'package:example/article/use_cases/update_article_use_case.dart';
import 'package:flutter_cms/data_types/attribut_implementations/cms_attribut_string.dart';
import 'package:flutter_cms/data_types/attribut_implementations/cms_attribut_image.dart';
import 'package:flutter_cms/data_types/attribut_implementations/cms_attribut_bool.dart';
import 'package:flutter_cms/data_types/attribut_implementations/cms_attribut_date_time.dart';
import 'package:flutter_cms/data_types/cms_object_structure.dart';

final articleCmsObject = CmsObjectStructure(
  id: "article",
  displayName: "Article",
  attributes: [
    const CmsAttributString(
      id: "title",
      displayName: "Title",
      canObjectBeSortedByThisAttribut: true,
    ),
    const CmsAttributString(
      id: "description",
      displayName: "Description",
      canObjectBeSortedByThisAttribut: true,
    ),
    const CmsAttributImage(
      id: "image",
      displayName: "Image",
      canObjectBeSortedByThisAttribut: false,
      shouldBeDisplayedOnOverviewTable: false,
    ),
    CmsAttributDateTime(
      id: "timestamp",
      displayName: "Created at",
      canObjectBeSortedByThisAttribut: true,
      shouldBeDisplayedOnOverviewTable: false,
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
  ],
  onCreateCmsObject: createArticle,
  onUpdateCmsObject: updateArticle,
  loadCmsObjectById: loadArticleById,
  onLoadCmsObjects: loadArticles,
  onDeleteCmsObject: deleteArticle,
);
