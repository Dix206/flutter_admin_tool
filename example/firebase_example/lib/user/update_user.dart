import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_example/user/app_user_dto.dart';
import 'package:firebase_example/user/user_flat_object.dart';
import 'package:flutter_admin_tool/flat.dart';

Future<FlatResult<Unit>> updateUser(FlatObjectValue flatObjectValue) async {
  try {
    final event = AppUserDto.fromFlatObjectValue(flatObjectValue: flatObjectValue);

    await FirebaseFirestore.instance.collection(appUserFirebaseCollectionId).doc(event.id).set(event.toJson());
    return FlatResult.success(const Unit());
  } catch (exception) {
    return FlatResult.error("Es ist ein Fehler aufgetreten. Bitte probiere es erneut.");
  }
}
