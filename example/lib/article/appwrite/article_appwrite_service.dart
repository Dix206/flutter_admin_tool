import 'package:appwrite/appwrite.dart';
import 'package:example/appwrite/client.dart';
import 'package:example/article/appwrite/dtos/article_appwrite_dto.dart';
import 'package:example/constants.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cms/data_types/attribut_implementations/cms_attribut_image.dart';
import 'package:flutter_cms/data_types/cms_object_value.dart';
import 'package:flutter_cms/data_types/result.dart';
import 'package:uuid/uuid.dart';

final articleAppwriteService = ArticleAppwriteService(
  databases,
  storage,
);

class ArticlesList {
  final List<ArticleAppwriteDto> articles;
  final bool hasMoreItems;

  ArticlesList({
    required this.articles,
    required this.hasMoreItems,
  });
}

class ArticleAppwriteService {
  final Databases _databases;
  final Storage _storage;

  ArticleAppwriteService(
    this._databases,
    this._storage,
  );

  Future<Result<ArticleAppwriteDto>> loadArticleById(String articleId) async {
    try {
      final document = await _databases.getDocument(
        databaseId: databaseId,
        collectionId: articleCollectionId,
        documentId: articleId,
      );

      return Result.success(ArticleAppwriteDto.fromJson(document.data));
    } catch (exception) {
      return Result.error("Failed to load article with ID $articleId.");
    }
  }

  Future<Result<ArticlesList>> loadArticles({
    required String? lastArticleId,
  }) async {
    try {
      final databaseList = await _databases.listDocuments(
        databaseId: databaseId,
        collectionId: articleCollectionId,
        queries: [
          Query.limit(3),
          if (lastArticleId != null) Query.cursorAfter(lastArticleId),
        ],
      );

      return Result.success(
        ArticlesList(
          articles: databaseList.documents.map((document) => ArticleAppwriteDto.fromJson(document.data)).toList(),
          hasMoreItems: 3 == databaseList.documents.length,
        ),
      );
    } catch (exception) {
      return Result.error("Failed to load articles. Please try again");
    }
  }

  Future<Result<Unit>> uploadImage({
    required String articleId,
    required Uint8List data,
  }) async {
    try {
      await _storage.createFile(
        bucketId: "articles",
        fileId: articleId,
        file: InputFile(
          bytes: data,
          filename: articleId,
        ),
      );

      return Result.success(const Unit());
    } catch (exception) {
      return Result.error("Failed to upload media. Please try again");
    }
  }

  Future<Result<Unit>> createArticle(CmsObjectValue cmsObjectValue) async {
    try {
      final id = const Uuid().v4();
      final imageData = cmsObjectValue.getValueByName('Image') as ImageValue?;

      if (imageData?.imageData != null) {
        final result = await uploadImage(
          data: imageData!.imageData!,
          articleId: id,
        );

        return result.fold(
            onError: (error) => Result.error(error),
            onSuccess: (url) async {
              final articleAppwriteDto = ArticleAppwriteDto.fromCmsObjectValue(
                cmsObjectValue: cmsObjectValue,
                id: id,
                imageUrl: '$appwriteHost/storage/buckets/articles/files/$id/view?project=$appwriteProjectId',
              );

              await _databases.createDocument(
                databaseId: databaseId,
                collectionId: articleCollectionId,
                data: articleAppwriteDto.toJson(),
                documentId: articleAppwriteDto.id,
              );
              return Result.success(const Unit());
            });
      }

      final articleAppwriteDto = ArticleAppwriteDto.fromCmsObjectValue(
        cmsObjectValue: cmsObjectValue,
        id: id,
      );

      await _databases.createDocument(
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

  Future<Result<Unit>> updateArticle(CmsObjectValue cmsObjectValue) async {
    try {
      final imageData = cmsObjectValue.getValueByName('Image') as ImageValue?;

      if (imageData?.imageData != null) {
        final result = await uploadImage(
          data: imageData!.imageData!,
          articleId: cmsObjectValue.id as String,
        );

        return result.fold(
            onError: (error) => Result.error(error),
            onSuccess: (url) async {
              final articleAppwriteDto = ArticleAppwriteDto.fromCmsObjectValue(
                cmsObjectValue: cmsObjectValue,
                id: cmsObjectValue.id as String,
                imageUrl:
                    '$appwriteHost/storage/buckets/articles/files/${cmsObjectValue.id as String}/view?project=$appwriteProjectId',
              );

              await _databases.updateDocument(
                databaseId: databaseId,
                collectionId: articleCollectionId,
                data: articleAppwriteDto.toJson(),
                documentId: articleAppwriteDto.id,
              );
              return Result.success(const Unit());
            });
      }

      final articleAppwriteDto = ArticleAppwriteDto.fromCmsObjectValue(
        cmsObjectValue: cmsObjectValue,
        id: cmsObjectValue.id as String,
      );

      await _databases.updateDocument(
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

  Future<Result<Unit>> deleteArticle(String articleId) async {
    try {
      await _databases.deleteDocument(
        databaseId: databaseId,
        collectionId: articleCollectionId,
        documentId: articleId,
      );
      return Result.success(const Unit());
    } catch (exception) {
      return Result.error("Failed to delete article. Please try again");
    }
  }
}
