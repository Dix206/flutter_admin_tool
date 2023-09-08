import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_example/constants.dart';
import 'package:firebase_example/event/event.dart';
import 'package:flutter_admin_tool/flat.dart';

Future<FlatResult<Unit>> updateEvent(FlatObjectValue flatObjectValue) async {
  try {
    final event = Event.fromFlatObjectValue(flatObjectValue: flatObjectValue);

    await FirebaseFirestore.instance
        .collection(eventCollectionId)
        .doc(event.id)
        .set(event.toJson());
    return FlatResult.success(const Unit());
  } catch (exception) {
    return FlatResult.error("Failed to update event. Please try again");
  }
}
