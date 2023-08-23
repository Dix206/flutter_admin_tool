import 'package:example/appwrite/client.dart';
import 'package:example/constants.dart';
import 'package:example/event/event.dart';
import 'package:flutter_admin_tool/data_types/flat_object_value.dart';
import 'package:flutter_admin_tool/data_types/flat_result.dart';

Future<FlatResult<FlatObjectValue>> loadEventById(String eventId) async {
  try {
    final document = await databases.getDocument(
      databaseId: databaseId,
      collectionId: eventCollectionId,
      documentId: eventId,
    );

    final event = Event.fromJson(document.data);

    return FlatResult.success(
      event.toFlatObjectValue(),
    );
  } catch (exception) {
    return FlatResult.error("Failed to load event with ID $eventId.");
  }
}
