import 'package:example/appwrite/client.dart';
import 'package:example/constants.dart';
import 'package:example/event/event.dart';
import 'package:flutter_cms/data_types/cms_object_value.dart';
import 'package:flutter_cms/data_types/result.dart';

Future<Result<CmsObjectValue>> loadEventById(String eventId) async {
  try {
    final document = await databases.getDocument(
      databaseId: databaseId,
      collectionId: eventCollectionId,
      documentId: eventId,
    );

    final event = Event.fromJson(document.data);

    return Result.success(
      event.toCmsObjectValue(),
    );
  } catch (exception) {
    return Result.error("Failed to load event with ID $eventId.");
  }
}
