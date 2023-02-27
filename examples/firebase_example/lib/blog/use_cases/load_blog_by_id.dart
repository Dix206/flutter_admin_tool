import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_example/blog/blog.dart';
import 'package:firebase_example/constants.dart';
import 'package:flat/flat.dart';

Future<FlatResult<FlatObjectValue>> loadBlogById(String blogId) async {
  try {
    final snapshot = await FirebaseFirestore.instance.collection(blogCollectionId).doc(blogId).get();

    final blog = Blog.fromJson(snapshot.data()!);

    return FlatResult.success(
      blog.toFlatObjectValue(

      ),
    );
  } catch (exception) {
    return FlatResult.error("Failed to load blog with ID $blogId.");
  }
}
