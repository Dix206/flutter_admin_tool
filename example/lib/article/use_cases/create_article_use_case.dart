import 'package:example/appwrite/client.dart';
import 'package:example/article/article.dart';
import 'package:example/article/use_cases/article_image_service.dart';
import 'package:example/constants.dart';
import 'package:flutter_cms/data_types/attribut_implementations/cms_attribut_image/cms_attribut_image.dart';
import 'package:flutter_cms/data_types/cms_object_value.dart';
import 'package:flutter_cms/data_types/result.dart';
import 'package:uuid/uuid.dart';

Future<Result<Unit>> createArticle(CmsObjectValue cmsObjectValue) async {
  try {
    final id = const Uuid().v4();
    final imageData = cmsObjectValue.getAttributValueByAttributId<ImageValue?>('image');

    if (imageData?.imageData != null) {
      final imageId = const Uuid().v4();
      final result = await uploadArticleImage(
        data: imageData!.imageData!,
        imageId: id,
      );

      return result.fold(
          onError: (error) => Result.error(error),
          onSuccess: (url) async {
            final articleAppwriteDto = Article.fromCmsObjectValue(
              cmsObjectValue: cmsObjectValue,
              id: id,
              imageId: imageId,
            );

            await databases.createDocument(
              databaseId: databaseId,
              collectionId: articleCollectionId,
              data: articleAppwriteDto.toJson(),
              documentId: articleAppwriteDto.id,
            );
            return Result.success(const Unit());
          });
    }

    final articleAppwriteDto = Article.fromCmsObjectValue(
      cmsObjectValue: cmsObjectValue,
      id: id,
      imageId: null,
    );

    await databases.createDocument(
      databaseId: databaseId,
      collectionId: articleCollectionId,
      data: articleAppwriteDto.toJson(),
      documentId: articleAppwriteDto.id,
    );
    return Result.success(const Unit());
  } catch (exception) {
    return Result.error("Failed to create article. Please try again");
  }
}
