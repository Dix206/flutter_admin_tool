import 'package:example/appwrite/client.dart';
import 'package:example/article/article.dart';
import 'package:example/article/use_cases/upload_image.dart';
import 'package:example/constants.dart';
import 'package:flutter_cms/data_types/attribut_implementations/cms_attribut_image.dart';
import 'package:flutter_cms/data_types/cms_object_value.dart';
import 'package:flutter_cms/data_types/result.dart';
import 'package:uuid/uuid.dart';

Future<Result<Unit>> createArticle(CmsObjectValue cmsObjectValue) async {
    try {
      final id = const Uuid().v4();
      final imageData = cmsObjectValue.getAttributValueByAttributId<ImageValue?>('image');

      if (imageData?.imageData != null) {
        final result = await uploadImage(
          data: imageData!.imageData!,
          articleId: id,
        );

        return result.fold(
            onError: (error) => Result.error(error),
            onSuccess: (url) async {
              final articleAppwriteDto = Article.fromCmsObjectValue(
                cmsObjectValue: cmsObjectValue,
                id: id,
                imageUrl: '$appwriteHost/storage/buckets/articles/files/$id/view?project=$appwriteProjectId',
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