import 'package:flutter/material.dart';
import 'package:flutter_cms/data_types/attribute_implementations/cms_attribute_location/cms_location.dart';
import 'package:flutter_cms/data_types/cms_attribute_value.dart';
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
        CmsAttributeValue(id: 'id', value: id),
        CmsAttributeValue(id: 'title', value: title),
        CmsAttributeValue(id: 'price', value: price),
        CmsAttributeValue(id: 'phoneNumber', value: phoneNumber),
        CmsAttributeValue(id: 'email', value: email),
        CmsAttributeValue(
          id: 'location',
          value: locationLatitude != null && locationLongitude != null
              ? CmsLocation(
                  latitude: locationLatitude!,
                  longitude: locationLongitude!,
                )
              : null,
        ),
        CmsAttributeValue(id: 'eventType', value: eventType),
        CmsAttributeValue(id: 'neededItems', value: neededItems),
        CmsAttributeValue(id: 'startingTime', value: startingTime),
      ],
    );
  }

  factory Event.fromCmsObjectValue({
    required CmsObjectValue cmsObjectValue,
    String? id,
  }) {
    return Event(
      id: id ?? cmsObjectValue.id!,
      title: cmsObjectValue.getAttributeValueByAttributeId('title'),
      price: cmsObjectValue.getAttributeValueByAttributeId('price'),
      phoneNumber: cmsObjectValue.getAttributeValueByAttributeId('phoneNumber'),
      email: cmsObjectValue.getAttributeValueByAttributeId('email'),
      locationLatitude: (cmsObjectValue.getAttributeValueByAttributeId('location') as CmsLocation?)?.latitude,
      locationLongitude: (cmsObjectValue.getAttributeValueByAttributeId('location') as CmsLocation?)?.longitude,
      eventType: cmsObjectValue.getAttributeValueByAttributeId('eventType'),
      neededItems: (cmsObjectValue.getAttributeValueByAttributeId('neededItems') as List<dynamic>?)?.cast(),
      startingTime: cmsObjectValue.getAttributeValueByAttributeId('startingTime'),
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
