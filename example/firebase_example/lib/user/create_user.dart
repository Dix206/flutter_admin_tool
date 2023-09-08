import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_example/user/app_user_dto.dart';
import 'package:firebase_example/user/user_flat_object.dart';
import 'package:flutter_admin_tool/flat.dart';
import 'package:uuid/uuid.dart';

Future<FlatResult<Unit>> createUser(FlatObjectValue flatObjectValue) async {
  try {
    final id = const Uuid().v4();

    final event = AppUserDto.fromFlatObjectValue(
      flatObjectValue: flatObjectValue,
      id: id,
    );

    await FirebaseFirestore.instance.collection(appUserFirebaseCollectionId).doc(event.id).set(event.toJson());
    return FlatResult.success(const Unit());
  } catch (exception) {
    return FlatResult.error("Es ist ein Fehler aufgetreten. Bitte probiere es erneut.");
  }
}
