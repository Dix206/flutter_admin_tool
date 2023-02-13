import 'package:flutter/material.dart';
import 'package:flutter_cms/data_types/cms_attribut_value.dart';
import 'package:flutter_cms/data_types/cms_object_value.dart';

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

  CmsObjectValue toCmsObjectValue() {
    return CmsObjectValue(
      id: id,
      values: [
        CmsAttributValue(id: 'id', value: id),
        CmsAttributValue(id: 'title', value: title),
        CmsAttributValue(id: 'price', value: 1.1), // TODO
        CmsAttributValue(id: 'phoneNumber', value: phoneNumber),
        CmsAttributValue(id: 'email', value: email),
        CmsAttributValue(id: 'locationLatitude', value: null), // TODO
        CmsAttributValue(id: 'locationLongitude', value: null), // TODO
        CmsAttributValue(id: 'eventType', value: EventType.workshop), // TODO
        CmsAttributValue(id: 'neededItems', value: null), // TODO
        CmsAttributValue(id: 'startingTime', value: TimeOfDay.now()), // TODO
      ],
    );
  }

  factory Event.fromCmsObjectValue({
    required CmsObjectValue cmsObjectValue,
    String? id,
  }) {
    return Event(
      id: id ?? cmsObjectValue.id as String,
      title: cmsObjectValue.getAttributValueByAttributId('title'),
      // price: cmsObjectValue.getAttributValueByAttributId('price'), // TODO
      price: 0.0, // TODO
      phoneNumber: cmsObjectValue.getAttributValueByAttributId('phoneNumber'),
      email: cmsObjectValue.getAttributValueByAttributId('email'),
      // locationLatitude: cmsObjectValue.getAttributValueByAttributId('locationLatitude'), // TODO
      // locationLongitude: cmsObjectValue.getAttributValueByAttributId('locationLongitude'), // TODO
      locationLatitude: null, // TODO
      locationLongitude: null, // TODO
      // eventType: cmsObjectValue.getAttributValueByAttributId('eventType'), // TODO
      eventType: EventType.workshop, // TODO
      // neededItems: cmsObjectValue.getAttributValueByAttributId('neededItems'), // TODO
      neededItems: null, // TODO
      // startingTime: cmsObjectValue.getAttributValueByAttributId('startingTime'), // TODO
      startingTime: TimeOfDay.now(), // TODO
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
