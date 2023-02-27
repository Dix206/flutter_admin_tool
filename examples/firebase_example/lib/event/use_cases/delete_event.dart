import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_example/constants.dart';
import 'package:flat/flat.dart';

Future<FlatResult<Unit>> deleteEvent(String eventId) async {
  try {
    await FirebaseFirestore.instance.collection(eventCollectionId).doc(eventId).delete();
    return FlatResult.success(const Unit());
  } catch (exception) {
    return FlatResult.error("Failed to delete event. Please try again");
  }
}
