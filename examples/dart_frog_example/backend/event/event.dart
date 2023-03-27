class Event {
  Event({
    required this.id,
    required this.title,
    required this.price,
    required this.phoneNumber,
    required this.email,
    required this.locationLatitude,
    required this.locationLongitude,
    required this.eventType,
    required this.neededItems,
    required this.startingTime,
  });

  factory Event.fromJson(Map<String, dynamic> map) {
    return Event(
      id: map['id'] as String,
      title: map['title'] as String,
      price: map['price'] as double,
      phoneNumber: map['phoneNumber'] as String,
      email: map['email'] as String,
      locationLatitude: map['locationLatitude'] as double?,
      locationLongitude: map['locationLongitude'] as double?,
      eventType: map['eventType'] as String,
      neededItems: (map['neededItems'] as List<dynamic>?)?.cast(),
      startingTime: map['startingTime'] as double,
    );
  }
  final String id;
  final String title;
  final double price;
  final String phoneNumber;
  final String email;
  final double? locationLatitude;
  final double? locationLongitude;
  final String eventType;
  final List<String>? neededItems;
  final double startingTime;

  dynamic getAttributeByName(String name) {
    switch (name) {
      case 'id':
        return id;
      case 'title':
        return title;
      case 'price':
        return price;
      case 'phoneNumber':
        return phoneNumber;
      case 'email':
        return email;
      case 'locationLatitude':
        return locationLatitude;
      case 'locationLongitude':
        return locationLongitude;
      case 'eventType':
        return eventType;
      case 'neededItems':
        return neededItems;
      case 'startingTime':
        return startingTime;
      default:
        throw Exception('Attribute $name not found');
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'phoneNumber': phoneNumber,
      'email': email,
      'locationLatitude': locationLatitude,
      'locationLongitude': locationLongitude,
      'eventType': eventType,
      'neededItems': neededItems,
      'startingTime': startingTime,
    };
  }
}

enum EventType {
  event,
  workshop,
  course,
  other,
}
