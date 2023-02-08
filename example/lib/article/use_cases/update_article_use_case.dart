import 'package:example/appwrite/client.dart';
import 'package:example/article/article.dart';
import 'package:example/article/use_cases/upload_image.dart';
import 'package:example/constants.dart';
import 'package:flutter_cms/data_types/attribut_implementations/cms_attribut_image.dart';
import 'package:flutter_cms/data_types/cms_object_value.dart';
import 'package:flutter_cms/data_types/result.dart';

Future<Result<Unit>> updateArticle(CmsObjectValue cmsObjectValue) async {
  try {
    final imageData = cmsObjectValue.getAttributValueByAttributId<ImageValue?>('image');

    if (imageData?.imageData != null) {
      final result = await uploadImage(
        data: imageData!.imageData!,
        articleId: cmsObjectValue.id!,
      );

      return result.fold(
          onError: (error) => Result.error(error),
          onSuccess: (url) async {
            final articleAppwriteDto = Article.fromCmsObjectValue(
              cmsObjectValue: cmsObjectValue,
              id: cmsObjectValue.id!,
              imageUrl:
                  '$appwriteHost/storage/buckets/articles/files/${cmsObjectValue.id}/view?project=$appwriteProjectId',
            );

            await databases.updateDocument(
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
      id: cmsObjectValue.id as String,
    );

    await databases.updateDocument(
      databaseId: databaseId,
      collectionId: articleCollectionId,
      data: articleAppwriteDto.toJson(),
      documentId: articleAppwriteDto.id,
    );
    return Result.success(const Unit());
  } catch (exception) {
    return Result.error("Failed to update article. Please try again");
  }
}
