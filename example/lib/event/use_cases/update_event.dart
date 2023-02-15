import 'package:example/appwrite/client.dart';
import 'package:example/constants.dart';
import 'package:example/event/event.dart';
import 'package:flutter_cms/data_types/cms_object_value.dart';
import 'package:flutter_cms/data_types/cms_result.dart';

Future<CmsResult<Unit>> updateEvent(CmsObjectValue cmsObjectValue) async {
  try {
    final event = Event.fromCmsObjectValue(cmsObjectValue: cmsObjectValue);

    await databases.updateDocument(
      databaseId: databaseId,
      collectionId: eventCollectionId,
      data: event.toJson(),
      documentId: event.id,
    );
    return CmsResult.success(const Unit());
  } catch (exception) {
    return CmsResult.error("Failed to update event. Please try again");
  }
}
