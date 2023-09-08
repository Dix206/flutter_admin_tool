import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_example/constants.dart';
import 'package:flutter_admin_tool/flat.dart';

Future<FlatResult<Unit>> deleteEvent(String eventId) async {
  try {
    await FirebaseFirestore.instance
        .collection(eventCollectionId)
        .doc(eventId)
        .delete();
    return FlatResult.success(const Unit());
  } catch (exception) {
    return FlatResult.error("Failed to delete event. Please try again");
  }
}
