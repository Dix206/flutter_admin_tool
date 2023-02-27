import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_example/constants.dart';
import 'package:firebase_example/event/event.dart';
import 'package:flat/data_types/flat_object_value.dart';
import 'package:flat/data_types/flat_result.dart';

Future<FlatResult<FlatObjectValue>> loadEventById(String eventId) async {
  try {
    final documentSnapshot = await FirebaseFirestore.instance.collection(eventCollectionId).doc(eventId).get();

    final event = Event.fromJson(documentSnapshot.data()!);

    return FlatResult.success(
      event.toFlatObjectValue(),
    );
  } catch (exception) {
    return FlatResult.error("Failed to load event with ID $eventId.");
  }
}
