import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_example/user/app_user_dto.dart';
import 'package:firebase_example/user/user_flat_object.dart';
import 'package:flutter_admin_tool/flat.dart';

Future<FlatResult<FlatObjectValue>> loadUserById(String eventId) async {
  try {
    final documentSnapshot = await FirebaseFirestore.instance.collection(userFirebaseCollectionId).doc(eventId).get();

    final user = AppUserDto.fromJson(documentSnapshot.data()!);

    return FlatResult.success(
      user.toFlatObjectValue(),
    );
  } catch (exception) {
    return FlatResult.error("Es ist ein Fehler aufgetreten. Bitte probiere es erneut.");
  }
}
