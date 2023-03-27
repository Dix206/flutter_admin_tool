import 'package:flat/flat.dart';
import 'package:frontend/event/client.dart';
import 'package:frontend/event/event.dart';
import 'package:uuid/uuid.dart';

Future<FlatResult<Unit>> createEvent(FlatObjectValue flatObjectValue) async {
  try {
    final id = const Uuid().v4();

    final event = Event.fromFlatObjectValue(
      flatObjectValue: flatObjectValue,
      id: id,
    );

    final result = await client.post(
      "/event",
      data: event.toJson(),
    );

    return result.statusCode == 200
        ? FlatResult.success(const Unit())
        : FlatResult.error("Failed to create event. Please try again");
  } catch (exception) {
    return FlatResult.error("Failed to create event. Please try again");
  }
}
