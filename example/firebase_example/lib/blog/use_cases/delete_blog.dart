import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_example/constants.dart';
import 'package:flutter_admin_tool/flat.dart';

Future<FlatResult<Unit>> deleteBlog(String blogId) async {
  try {
    await FirebaseFirestore.instance.collection(blogCollectionId).doc(blogId).delete();
    return FlatResult.success(const Unit());
  } catch (exception) {
    return FlatResult.error("Failed to delete blog. Please try again");
  }
}
