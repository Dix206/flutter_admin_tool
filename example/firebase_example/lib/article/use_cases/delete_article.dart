import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_example/constants.dart';
import 'package:flutter_admin_tool/flat.dart';

Future<FlatResult<Unit>> deleteArticle(String articleId) async {
  try {
    await FirebaseFirestore.instance.collection(articleCollectionId).doc(articleId).delete();
    return FlatResult.success(const Unit());
  } catch (exception) {
    return FlatResult.error("Failed to delete article. Please try again");
  }
}
