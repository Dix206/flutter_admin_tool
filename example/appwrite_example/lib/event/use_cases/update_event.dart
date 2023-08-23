import 'package:example/appwrite/client.dart';
import 'package:example/constants.dart';
import 'package:example/event/event.dart';
import 'package:flutter_admin_tool/flat.dart';

Future<FlatResult<Unit>> updateEvent(FlatObjectValue flatObjectValue) async {
  try {
    final event = Event.fromFlatObjectValue(flatObjectValue: flatObjectValue);

    await databases.updateDocument(
      databaseId: databaseId,
      collectionId: eventCollectionId,
      data: event.toJson(),
      documentId: event.id,
    );
    return FlatResult.success(const Unit());
  } catch (exception) {
    return FlatResult.error("Failed to update event. Please try again");
  }
}
