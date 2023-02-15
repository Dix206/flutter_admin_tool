import 'package:example/appwrite/client.dart';
import 'package:example/constants.dart';
import 'package:example/event/event.dart';
import 'package:flutter_cms/data_types/cms_object_value.dart';
import 'package:flutter_cms/data_types/cms_result.dart';

Future<CmsResult<CmsObjectValue>> loadEventById(String eventId) async {
  try {
    final document = await databases.getDocument(
      databaseId: databaseId,
      collectionId: eventCollectionId,
      documentId: eventId,
    );

    final event = Event.fromJson(document.data);

    return CmsResult.success(
      event.toCmsObjectValue(),
    );
  } catch (exception) {
    return CmsResult.error("Failed to load event with ID $eventId.");
  }
}
