import 'package:flutter/material.dart';

import 'package:flutter_cms/data_types/cms_attribut_value.dart';
import 'package:flutter_cms/data_types/cms_object_value.dart';

class Blog {
  final String id;
  final String title;
  final String content;
  final DateTime day;
  final int sortOrder;
  final Color? color;

  Blog({
    required this.id,
    required this.title,
    required this.content,
    required this.day,
    required this.sortOrder,
    required this.color,
  });

  CmsObjectValue toCmsObjectValue() {
    return CmsObjectValue(
      id: id,
      values: [
        CmsAttributValue(id: 'id', value: id),
        CmsAttributValue(id: 'title', value: title),
        CmsAttributValue(id: 'content', value: content),
        CmsAttributValue(id: 'day', value: day),
        CmsAttributValue(id: 'sortOrder', value: sortOrder),
        CmsAttributValue(id: 'color', value: color),
      ],
    );
  }

  factory Blog.fromCmsObjectValue({
    required CmsObjectValue cmsObjectValue,
    String? id,
  }) {
    return Blog(
      id: id ?? cmsObjectValue.id as String,
      title: cmsObjectValue.getAttributValueByAttributId('title'),
      content: cmsObjectValue.getAttributValueByAttributId('content'),
      day: cmsObjectValue.getAttributValueByAttributId('day'),
      sortOrder: cmsObjectValue.getAttributValueByAttributId('sortOrder'),
      color: null,
      // color: cmsObjectValue.getAttributValueByAttributId('color'), // TODO
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
    );
  }
}
