import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_example/article/article.dart';
import 'package:firebase_example/constants.dart';
import 'package:flutter_admin_tool/flat.dart';

Future<FlatResult<FlatObjectValue>> loadArticleById(String articleId) async {
  try {
    final snapshot = await FirebaseFirestore.instance
        .collection(articleCollectionId)
        .doc(articleId)
        .get();

    final article = Article.fromJson(snapshot.data()!);

    final authorSnapshot = article.authorId == null
        ? null
        : await FirebaseFirestore.instance
            .collection(authorCollectionId)
            .doc(article.authorId!)
            .get();

    return FlatResult.success(
      article.toFlatObjectValue(
        author: authorSnapshot == null
            ? null
            : Author.fromJson(authorSnapshot.data()!),
      ),
    );
  } catch (exception) {
    return FlatResult.error("Failed to load article with ID $articleId.");
  }
}
