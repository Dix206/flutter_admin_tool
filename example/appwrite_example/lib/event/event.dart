import 'package:flutter/material.dart';
import 'package:flutter_admin_tool/flat.dart';

class Event {
  final String id;
  final String title;
  final double price;
  final String phoneNumber;
  final String email;
  final double? locationLatitude;
  final double? locationLongitude;
  final EventType eventType;
  final List<String>? neededItems;
  final TimeOfDay startingTime;

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

  FlatObjectValue toFlatObjectValue() {
    return FlatObjectValue(
      id: id,
      values: [
        FlatAttributeValue(id: 'id', value: id),
        FlatAttributeValue(id: 'title', value: title),
        FlatAttributeValue(id: 'price', value: price),
        FlatAttributeValue(id: 'phoneNumber', value: phoneNumber),
        FlatAttributeValue(id: 'email', value: email),
        FlatAttributeValue(
          id: 'location',
          value: locationLatitude != null && locationLongitude != null
              ? FlatLocation(
                  latitude: locationLatitude!,
                  longitude: locationLongitude!,
                )
              : null,
        ),
        FlatAttributeValue(id: 'eventType', value: eventType),
        FlatAttributeValue(id: 'neededItems', value: neededItems),
        FlatAttributeValue(id: 'startingTime', value: startingTime),
      ],
    );
  }

  factory Event.fromFlatObjectValue({
    required FlatObjectValue flatObjectValue,
    String? id,
  }) {
    return Event(
      id: id ?? flatObjectValue.id!,
      title: flatObjectValue.getAttributeValueByAttributeId('title'),
      price: flatObjectValue.getAttributeValueByAttributeId('price'),
      phoneNumber: flatObjectValue.getAttributeValueByAttributeId('phoneNumber'),
      email: flatObjectValue.getAttributeValueByAttributeId('email'),
      locationLatitude: (flatObjectValue.getAttributeValueByAttributeId('location') as FlatLocation?)?.latitude,
      locationLongitude: (flatObjectValue.getAttributeValueByAttributeId('location') as FlatLocation?)?.longitude,
      eventType: flatObjectValue.getAttributeValueByAttributeId('eventType'),
      neededItems: (flatObjectValue.getAttributeValueByAttributeId('neededItems') as List<dynamic>?)?.cast(),
      startingTime: flatObjectValue.getAttributeValueByAttributeId('startingTime'),
    );
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
      'eventType': eventType.name,
      'neededItems': neededItems,
      'startingTime': startingTime.hour + startingTime.minute / 100,
    };
  }

  factory Event.fromJson(Map<String, dynamic> map) {
    return Event(
      id: map['id'] as String,
      title: map['title'] as String,
      price: map['price'] as double,
      phoneNumber: map['phoneNumber'] as String,
      email: map['email'] as String,
      locationLatitude: map['locationLatitude'] as double?,
      locationLongitude: map['locationLongitude'] as double?,
      eventType: EventType.values.byName(map['eventType']),
      neededItems: (map['neededItems'] as List<dynamic>?)?.cast(),
      startingTime: TimeOfDay(
        hour: (map['startingTime'] as double).floor(),
        minute: ((map['startingTime'] as double) % 1 * 60).toInt(),
      ),
    );
  }
}

enum EventType {
  event,
  workshop,
  course,
  other,
}
