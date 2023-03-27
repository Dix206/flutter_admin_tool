import 'package:flat/flat.dart';
import 'package:frontend/event/client.dart';

Future<FlatResult<Unit>> deleteEvent(String eventId) async {
  try {
    final result = await client.delete(
      "/event/$eventId",
    );

    return result.statusCode == 200
        ? FlatResult.success(const Unit())
        : FlatResult.error("Failed to delete event. Please try again");
  } catch (exception) {
    return FlatResult.error("Failed to delete event. Please try again");
  }
}
