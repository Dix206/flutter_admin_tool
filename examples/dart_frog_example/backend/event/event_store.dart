import '../event/event.dart';
import '../models/filter.dart';

class EventStore {
  EventStore();

  final Map<String, Event> _events = {};

  void insertEvent(Event event) {
    _events[event.id] = event;
  }

  Event? getEvent(String id) {
    return _events[id];
  }

  List<Event> getFilteredEvents(Filter filter) {
    final allEvents = _events.values.toList();
    final filteredEvents = filter.searchQuery == null
        ? allEvents
        : allEvents
            .where(
              (event) => event.title.toLowerCase().contains(
                    filter.searchQuery!.toLowerCase(),
                  ),
            )
            .toList();

    if (filter.sortOptions != null) {
      filteredEvents.sort(
        (prev, curr) {
          final prevAttribute = prev.getAttributeByName(
            filter.sortOptions!.attributeId,
          );
          final currAttribute = curr.getAttributeByName(
            filter.sortOptions!.attributeId,
          );

          if (filter.sortOptions!.ascending) {
            return (prevAttribute as Comparable).compareTo(currAttribute);
          } else {
            return (currAttribute as Comparable).compareTo(prevAttribute);
          }
        },
      );
    }

    final startIndex = filter.page * filter.pageSize;
    final endIndex = startIndex + filter.pageSize;

    return startIndex > filteredEvents.length
        ? []
        : filteredEvents.sublist(
            startIndex,
            filteredEvents.length < endIndex ? filteredEvents.length : endIndex,
          );
  }

  List<Event> getAllEvents() {
    return _events.values.toList();
  }

  void deleteEvent(String id) {
    _events.remove(id);
  }
}
