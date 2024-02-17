import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_example/article/article.dart';
import 'package:firebase_example/constants.dart';
import 'package:flutter_admin_tool/flat.dart';

Future<FlatResult<List<Author>>> loadAuthors(String searchQuery) async {
  try {
    final snapshots =
        await FirebaseFirestore.instance.collection(authorCollectionId).where("name", isGreaterThan: searchQuery).get();

    return FlatResult.success(
      snapshots.docs.map((document) => Author.fromJson(document.data())).toList(),
    );
  } catch (exception) {
    return FlatResult.error("Failed to load authors. Please try again");
  }
}
