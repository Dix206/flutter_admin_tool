import 'package:example/appwrite/client.dart';
import 'package:example/constants.dart';
import 'package:flutter_cms/data_types/result.dart';

Future<Result<Unit>> deleteEvent(String eventId) async {
  try {
    await databases.deleteDocument(
      databaseId: databaseId,
      collectionId: eventCollectionId,
      documentId: eventId,
    );
    return Result.success(const Unit());
  } catch (exception) {
    return Result.error("Failed to delete event. Please try again");
  }
}
