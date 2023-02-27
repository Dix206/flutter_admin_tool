import 'package:example/constants.dart';
import 'package:flutter/material.dart';
import 'package:flat/flat.dart';

class Blog {
  final String id;
  final String title;
  final String content;
  final DateTime day;
  final int sortOrder;
  final Color? color;
  final String? fileId;

  Blog({
    required this.id,
    required this.title,
    required this.content,
    required this.day,
    required this.sortOrder,
    required this.color,
    required this.fileId,
  });

  FlatObjectValue toFlatObjectValue(Map<String, String> authHeaders) {
    return FlatObjectValue(
      id: id,
      values: [
        FlatAttributeValue(id: 'id', value: id),
        FlatAttributeValue(id: 'title', value: title),
        FlatAttributeValue(id: 'content', value: content),
        FlatAttributeValue(id: 'day', value: day),
        FlatAttributeValue(id: 'sortOrder', value: sortOrder),
        FlatAttributeValue(id: 'color', value: color),
        FlatAttributeValue(
          id: 'file',
          value: FlatFileValue(
            url: fileId != null
                ? '$appwriteHost/storage/buckets/blog/files/$fileId/view?project=$appwriteProjectId'
                : null,
            data: null,
            fileName: null,
            authHeaders: authHeaders,
            wasDeleted: false,
          ),
        ),
      ],
    );
  }

  factory Blog.fromFlatObjectValue({
    required FlatObjectValue flatObjectValue,
    String? id,
    required String? fileId,
  }) {
    return Blog(
      id: id ?? flatObjectValue.id as String,
      title: flatObjectValue.getAttributeValueByAttributeId('title'),
      content: flatObjectValue.getAttributeValueByAttributeId('content'),
      day: flatObjectValue.getAttributeValueByAttributeId('day'),
      sortOrder: flatObjectValue.getAttributeValueByAttributeId('sortOrder'),
      color: flatObjectValue.getAttributeValueByAttributeId('color'),
      fileId: fileId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'day':
          "${day.year.toString().padLeft(4, '0')}-${day.month.toString().padLeft(2, '0')}-${day.day.toString().padLeft(2, '0')}",
      'sortOrder': sortOrder,
      'color': color?.value,
      'fileId': fileId,
    };
  }

  factory Blog.fromJson(Map<String, dynamic> map) {
    return Blog(
      id: map['id'] as String,
      title: map['title'] as String,
      content: map['content'] as String,
      day: DateTime.parse(map['day']),
      sortOrder: map['sortOrder'] as int,
      color: map['color'] == null ? null : Color(map['color']),
      fileId: map['fileId'] as String?,
    );
  }
}
