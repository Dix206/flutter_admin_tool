import 'package:example/appwrite/client.dart';
import 'package:example/constants.dart';
import 'package:example/event/event.dart';
import 'package:flutter_cms/data_types/cms_object_value.dart';
import 'package:flutter_cms/data_types/result.dart';
import 'package:uuid/uuid.dart';

Future<Result<Unit>> createEvent(CmsObjectValue cmsObjectValue) async {
  try {
    final id = const Uuid().v4();

    final event = Event.fromCmsObjectValue(
      cmsObjectValue: cmsObjectValue,
      id: id,
    );

    await databases.createDocument(
      databaseId: databaseId,
      collectionId: eventCollectionId,
      data: event.toJson(),
      documentId: event.id,
    );
    return Result.success(const Unit());
  } catch (exception) {
    return Result.error("Failed to create event. Please try again");
  }
}
