import 'package:dart_frog/dart_frog.dart';
import '../event/event_store.dart';

final _eventStore = EventStore();

Handler middleware(Handler handler) {
  return handler.use(requestLogger()).use(
        provider<EventStore>((_) => _eventStore),
      );
}
