import 'package:example/appwrite/client.dart';
import 'package:example/article/article.dart';
import 'package:example/article/use_cases/article_image_service.dart';
import 'package:example/constants.dart';
import 'package:flutter_cms/data_types/cms_file_value.dart';
import 'package:flutter_cms/data_types/cms_object_value.dart';
import 'package:flutter_cms/data_types/cms_result.dart';
import 'package:uuid/uuid.dart';

Future<CmsResult<Unit>> createArticle(CmsObjectValue cmsObjectValue) async {
  try {
    final id = const Uuid().v4();
    final imageData = cmsObjectValue.getAttributValueByAttributId<CmsFileValue?>('image');

    if (imageData?.data != null) {
      final imageId = const Uuid().v4();
      final result = await uploadArticleImage(
        data: imageData!.data!,
        imageId: imageId,
      );

      return result.fold(
          onError: (error) => CmsResult.error(error),
          onSuccess: (url) async {
            final article = Article.fromCmsObjectValue(
              cmsObjectValue: cmsObjectValue,
              id: id,
              imageId: imageId,
            );

            await databases.createDocument(
              databaseId: databaseId,
              collectionId: articleCollectionId,
              data: article.toJson(),
              documentId: article.id,
            );
            return CmsResult.success(const Unit());
          });
    }

    final article = Article.fromCmsObjectValue(
      cmsObjectValue: cmsObjectValue,
      id: id,
      imageId: null,
    );

    await databases.createDocument(
      databaseId: databaseId,
      collectionId: articleCollectionId,
      data: article.toJson(),
      documentId: article.id,
    );
    return CmsResult.success(const Unit());
  } catch (exception) {
    return CmsResult.error("Failed to create article. Please try again");
  }
}
