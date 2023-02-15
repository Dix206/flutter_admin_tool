import 'package:example/appwrite/client.dart';
import 'package:example/constants.dart';
import 'package:flutter_cms/data_types/cms_result.dart';

Future<CmsResult<Unit>> deleteEvent(String eventId) async {
  try {
    await databases.deleteDocument(
      databaseId: databaseId,
      collectionId: eventCollectionId,
      documentId: eventId,
    );
    return CmsResult.success(const Unit());
  } catch (exception) {
    return CmsResult.error("Failed to delete event. Please try again");
  }
}
