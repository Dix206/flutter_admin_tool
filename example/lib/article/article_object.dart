import 'package:example/article/appwrite/dtos/article_appwrite_dto.dart';
import 'package:flutter_cms/data_types/attribut_implementations/cms_attribut_string.dart';
import 'package:flutter_cms/data_types/attribut_implementations/cms_attribut_bool.dart';
import 'package:flutter_cms/data_types/attribut_implementations/cms_attribut_date_time.dart';
import 'package:flutter_cms/data_types/cms_object.dart';
import 'package:flutter_cms/data_types/cms_object_value.dart';
import 'package:flutter_cms/data_types/result.dart';
import 'package:example/article/appwrite/article_appwrite_service.dart';
import 'package:uuid/uuid.dart';

final articleCmsObject = CmsObject(
  name: "Article",
  attributes: [
    const CmsAttributString(
      name: "Title",
      canObjectBeSortedByThisAttribut: true,
    ),
    const CmsAttributString(
      name: "Description",
      canObjectBeSortedByThisAttribut: true,
    ),
    // TODO IMAGE
    CmsAttributDateTime(
      name: "Created",
      canObjectBeSortedByThisAttribut: true,
      shouldBeDisplayedOnOverviewTable: true,
      invalidValueErrorMessage: "You have to enter a date time",
      minDateTime: DateTime(2020),
      maxDateTime: DateTime.now().add(const Duration(days: 365)),
    ),
    const CmsAttributBool(
      name: "IsActive",
      canObjectBeSortedByThisAttribut: true,
      shouldBeDisplayedOnOverviewTable: true,
    ),
  ],
  idToString: (id) => id.toString(),
  stringToId: (id) => id,
  onCreateCmsObject: (cmsObjectValue) => articleAppwriteService.createArticle(
    ArticleAppwriteDto.fromCmsObjectValue(
      cmsObjectValue: cmsObjectValue,
      id: const Uuid().v4(),
    ),
  ),
  onUpdateCmsObject: (cmsObjectValue) => articleAppwriteService.updateArticle(
    ArticleAppwriteDto.fromCmsObjectValue(cmsObjectValue: cmsObjectValue),
  ),
  loadCmsObjectById: (id) async {
    final result = await articleAppwriteService.loadArticleById(id as String);

    return result.fold(
      onError: (error) => Result.error(error),
      onSuccess: (article) => Result.success(article.toCmsObjectValue()),
    );
  },
  onLoadCmsObjects: ({
    lastLoadedCmsObjectId,
    searchQuery,
    required sortOptions,
  }) async {
    final result = await articleAppwriteService.loadArticles(
      lastArticleId: lastLoadedCmsObjectId as String?,
    );

    return result.fold(
      onError: (error) => Result.error(error),
      onSuccess: (articles) => Result.success(
        CmsObjectValueList(
          cmsObjectValues: articles.articles
              .map(
                (article) => article.toCmsObjectValue(),
              )
              .toList(),
          hasMoreItems: articles.hasMoreItems,
        ),
      ),
    );
  },
);
