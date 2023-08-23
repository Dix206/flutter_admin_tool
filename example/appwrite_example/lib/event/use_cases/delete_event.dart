import 'package:example/appwrite/client.dart';
import 'package:example/constants.dart';
import 'package:flutter_admin_tool/flat.dart';

Future<FlatResult<Unit>> deleteEvent(String eventId) async {
  try {
    await databases.deleteDocument(
      databaseId: databaseId,
      collectionId: eventCollectionId,
      documentId: eventId,
    );
    return FlatResult.success(const Unit());
  } catch (exception) {
    return FlatResult.error("Failed to delete event. Please try again");
  }
}
