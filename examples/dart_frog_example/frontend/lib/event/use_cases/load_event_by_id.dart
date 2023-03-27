import 'package:flat/data_types/flat_object_value.dart';
import 'package:flat/data_types/flat_result.dart';
import 'package:frontend/event/client.dart';
import 'package:frontend/event/event.dart';

Future<FlatResult<FlatObjectValue>> loadEventById(String eventId) async {
  try {
    final result = await client.get(
      "/event/$eventId",
    );

    if (result.statusCode != 200) {
      return FlatResult.error("Failed to load event with ID $eventId.");
    }

    final event = Event.fromJson(result.data);

    return FlatResult.success(event.toFlatObjectValue());
  } catch (exception) {
    return FlatResult.error("Failed to load event with ID $eventId.");
  }
}
