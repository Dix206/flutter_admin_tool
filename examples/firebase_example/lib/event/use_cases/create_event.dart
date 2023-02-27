import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_example/constants.dart';
import 'package:firebase_example/event/event.dart';
import 'package:flat/flat.dart';
import 'package:uuid/uuid.dart';

Future<FlatResult<Unit>> createEvent(FlatObjectValue flatObjectValue) async {
  try {
    final id = const Uuid().v4();

    final event = Event.fromFlatObjectValue(
      flatObjectValue: flatObjectValue,
      id: id,
    );

    await FirebaseFirestore.instance.collection(eventCollectionId).doc(event.id).set(event.toJson());
    return FlatResult.success(const Unit());
  } catch (exception) {
    return FlatResult.error("Failed to create event. Please try again");
  }
}
