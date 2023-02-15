import 'package:example/appwrite/client.dart';
import 'package:example/article/article.dart';
import 'package:example/article/use_cases/article_image_service.dart';
import 'package:example/constants.dart';
import 'package:flutter_cms/data_types/cms_file_value.dart';
import 'package:flutter_cms/data_types/cms_object_value.dart';
import 'package:flutter_cms/data_types/cms_result.dart';
import 'package:uuid/uuid.dart';

Future<CmsResult<Unit>> updateArticle(CmsObjectValue cmsObjectValue) async {
  try {
    final document = await databases.getDocument(
      databaseId: databaseId,
      collectionId: articleCollectionId,
      documentId: cmsObjectValue.id!,
    );

    final article = Article.fromJson(document.data);

    return _updateArticleFromExistingArticle(
      article: article,
      cmsObjectValue: cmsObjectValue,
    );
  } catch (exception) {
    return CmsResult.error("Failed to update article. Please try again");
  }
}

Future<CmsResult<Unit>> _updateArticleFromExistingArticle({
  required CmsObjectValue cmsObjectValue,
  required Article article,
}) async {
  try {
    final imageData = cmsObjectValue.getAttributValueByAttributId<CmsFileValue?>('image');

    if (imageData?.data != null) {
      final imageId = const Uuid().v4();

      if (article.imageId != null) {
        await deleteArticleImage(imageId: article.imageId!);
      }

      final result = await uploadArticleImage(
        data: imageData!.data!,
        imageId: imageId,
      );

      return result.fold(
        onError: (error) => CmsResult.error(error),
        onSuccess: (url) async {
          final newArticle = Article.fromCmsObjectValue(
            cmsObjectValue: cmsObjectValue,
            id: cmsObjectValue.id!,
            imageId: imageId,
          );

          await databases.updateDocument(
            databaseId: databaseId,
            collectionId: articleCollectionId,
            data: newArticle.toJson(),
            documentId: newArticle.id,
          );
          return CmsResult.success(const Unit());
        },
      );
    } else if (imageData?.wasDeleted == true && article.imageId != null) {
      final result = await deleteArticleImage(
        imageId: article.imageId!,
      );

      return result.fold(
        onError: (error) => CmsResult.error(error),
        onSuccess: (url) async {
          final newArticle = Article.fromCmsObjectValue(
            cmsObjectValue: cmsObjectValue,
            id: cmsObjectValue.id!,
            imageId: null,
          );

          await databases.updateDocument(
            databaseId: databaseId,
            collectionId: articleCollectionId,
            data: newArticle.toJson(),
            documentId: newArticle.id,
          );
          return CmsResult.success(const Unit());
        },
      );
    }

    final newArticle = Article.fromCmsObjectValue(
      cmsObjectValue: cmsObjectValue,
      id: cmsObjectValue.id!,
      imageId: article.imageId,
    );

    await databases.updateDocument(
      databaseId: databaseId,
      collectionId: articleCollectionId,
      data: newArticle.toJson(),
      documentId: newArticle.id,
    );
    return CmsResult.success(const Unit());
  } catch (exception) {
    return CmsResult.error("Failed to update article. Please try again");
  }
}
