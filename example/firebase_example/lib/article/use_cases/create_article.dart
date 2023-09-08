import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_example/article/article.dart';
import 'package:firebase_example/article/use_cases/article_image_service.dart';
import 'package:firebase_example/constants.dart';
import 'package:flutter_admin_tool/flat.dart';
import 'package:uuid/uuid.dart';

Future<FlatResult<Unit>> createArticle(FlatObjectValue flatObjectValue) async {
  try {
    final id = const Uuid().v4();
    final imageData =
        flatObjectValue.getAttributeValueByAttributeId<FlatFileValue?>('image');

    if (imageData?.data != null) {
      final imageId = const Uuid().v4();
      final result = await uploadArticleImage(
        data: imageData!.data!,
        imageId: imageId,
      );

      return result.fold(
          onError: (error) => FlatResult.error(error),
          onSuccess: (url) async {
            final article = Article.fromFlatObjectValue(
              flatObjectValue: flatObjectValue,
              id: id,
              imageId: imageId,
            );

            await FirebaseFirestore.instance
                .collection(articleCollectionId)
                .doc(article.id)
                .set(article.toJson());
            return FlatResult.success(const Unit());
          });
    }

    final article = Article.fromFlatObjectValue(
      flatObjectValue: flatObjectValue,
      id: id,
      imageId: null,
    );

    await FirebaseFirestore.instance
        .collection(articleCollectionId)
        .doc(article.id)
        .set(article.toJson());
    return FlatResult.success(const Unit());
  } catch (exception) {
    return FlatResult.error("Failed to create article. Please try again");
  }
}
