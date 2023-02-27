import 'package:example/appwrite/client.dart';
import 'package:example/constants.dart';
import 'package:example/event/event.dart';
import 'package:flat/flat.dart';
import 'package:uuid/uuid.dart';

Future<FlatResult<Unit>> createEvent(FlatObjectValue flatObjectValue) async {
  try {
    final id = const Uuid().v4();

    final event = Event.fromFlatObjectValue(
      flatObjectValue: flatObjectValue,
      id: id,
    );

    await databases.createDocument(
      databaseId: databaseId,
      collectionId: eventCollectionId,
      data: event.toJson(),
      documentId: event.id,
    );
    return FlatResult.success(const Unit());
  } catch (exception) {
    return FlatResult.error("Failed to create event. Please try again");
  }
}
