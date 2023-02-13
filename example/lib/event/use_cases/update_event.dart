import 'package:example/appwrite/client.dart';
import 'package:example/constants.dart';
import 'package:example/event/event.dart';
import 'package:flutter_cms/data_types/cms_object_value.dart';
import 'package:flutter_cms/data_types/result.dart';

Future<Result<Unit>> updateEvent(CmsObjectValue cmsObjectValue) async {
  try {
    final event = Event.fromCmsObjectValue(cmsObjectValue: cmsObjectValue);

    await databases.updateDocument(
      databaseId: databaseId,
      collectionId: eventCollectionId,
      data: event.toJson(),
      documentId: event.id,
    );
    return Result.success(const Unit());
  } catch (exception) {
    return Result.error("Failed to update event. Please try again");
  }
}
