import 'package:appwrite/appwrite.dart';
import 'package:example/appwrite/client.dart';
import 'package:example/article/appwrite/dtos/article_appwrite_dto.dart';
import 'package:flutter_cms/data_types/result.dart';

const _COLLECTION_ID = "63e0f6fa15ab4e76fbcd";
const _DATABASE_ID = "63e0f6f44088147089ea";

final articleAppwriteService = ArticleAppwriteService(databases);

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

  ArticleAppwriteService(
    this._databases,
  );

  Future<Result<ArticleAppwriteDto>> loadArticleById(String articleId) async {
    try {
      final document = await _databases.getDocument(
        databaseId: _DATABASE_ID,
        collectionId: _COLLECTION_ID,
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
        databaseId: _DATABASE_ID,
        collectionId: _COLLECTION_ID,
        queries: [
          Query.limit(10),
          if (lastArticleId != null) Query.cursorAfter(lastArticleId),
        ],
      );

      return Result.success(
        ArticlesList(
          articles: databaseList.documents.map((document) => ArticleAppwriteDto.fromJson(document.data)).toList(),
          hasMoreItems: 10 == databaseList.documents.length,
        ),
      );
    } catch (exception) {
      return Result.error("Failed to load articles. Please try again");
    }
  }

  Future<Result<Unit>> createArticle(ArticleAppwriteDto articleAppwriteDto) async {
    try {
      await _databases.createDocument(
        databaseId: _DATABASE_ID,
        collectionId: _COLLECTION_ID,
        data: articleAppwriteDto.toJson(),
        documentId: articleAppwriteDto.id,
      );
      return Result.success(const Unit());
    } catch (exception) {
      return Result.error("Failed to create article. Please try again");
    }
  }

  Future<Result<Unit>> updateArticle(ArticleAppwriteDto articleAppwriteDto) async {
    try {
      await _databases.updateDocument(
        databaseId: _DATABASE_ID,
        collectionId: _COLLECTION_ID,
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
        databaseId: _DATABASE_ID,
        collectionId: _COLLECTION_ID,
        documentId: articleId,
      );
      return Result.success(const Unit());
    } catch (exception) {
      return Result.error("Failed to delete article. Please try again");
    }
  }
}
