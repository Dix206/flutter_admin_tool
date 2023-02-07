import 'package:example/appwrite/client.dart';
import 'package:flutter_cms/data_types/attribut_implementations/cms_attribut_string.dart';
import 'package:flutter_cms/data_types/attribut_implementations/cms_attribut_image.dart';
import 'package:flutter_cms/data_types/attribut_implementations/cms_attribut_bool.dart';
import 'package:flutter_cms/data_types/attribut_implementations/cms_attribut_date_time.dart';
import 'package:flutter_cms/data_types/cms_object.dart';
import 'package:flutter_cms/data_types/cms_object_value.dart';
import 'package:flutter_cms/data_types/result.dart';
import 'package:example/article/appwrite/article_appwrite_service.dart';

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
    const CmsAttributImage(
      name: "Image",
      canObjectBeSortedByThisAttribut: false,
      shouldBeDisplayedOnOverviewTable: false,
    ),
    CmsAttributDateTime(
      name: "Timestamp",
      canObjectBeSortedByThisAttribut: true,
      shouldBeDisplayedOnOverviewTable: false,
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
  onCreateCmsObject: articleAppwriteService.createArticle,
  onUpdateCmsObject: articleAppwriteService.updateArticle,
  loadCmsObjectById: (id) async {
    final result = await articleAppwriteService.loadArticleById(id as String);
    final jwt = await account.createJWT();

    return result.fold(
      onError: (error) => Result.error(error),
      onSuccess: (article) => Result.success(
        article.toCmsObjectValue(
          {"x-appwrite-jwt": jwt.jwt},
        ),
      ),
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

    final jwt = await account.createJWT();

    return result.fold(
      onError: (error) => Result.error(error),
      onSuccess: (articles) => Result.success(
        CmsObjectValueList(
          cmsObjectValues: articles.articles
              .map(
                (article) => article.toCmsObjectValue(
                  {"x-appwrite-jwt": jwt.jwt},
                ),
              )
              .toList(),
          hasMoreItems: articles.hasMoreItems,
        ),
      ),
    );
  },
);
