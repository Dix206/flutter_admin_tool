import 'package:flutter_cms/data_types/attribut_implementations/cms_attribut_image.dart';
import 'package:flutter_cms/data_types/cms_attribut_value.dart';
import 'package:flutter_cms/data_types/cms_object_value.dart';

class Article {
  final String id;
  final String title;
  final String description;
  final String? imageUrl;
  final DateTime timestamp;
  final bool isActive;

  Article({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.timestamp,
    required this.isActive,
  });

  CmsObjectValue toCmsObjectValue(Map<String, String> authHeaders) {
    return CmsObjectValue(
      id: id,
      values: [
        CmsAttributValue(id: 'id', value: id),
        CmsAttributValue(id: 'title', value: title),
        CmsAttributValue(id: 'description', value: description),
        CmsAttributValue(
          id: 'image',
          value: ImageValue(
            imageUrl: imageUrl,
            imageData: null,
            headers: authHeaders,
          ),
        ),
        CmsAttributValue(id: 'timestamp', value: timestamp),
        CmsAttributValue(id: 'isActive', value: isActive),
      ],
    );
  }

  factory Article.fromCmsObjectValue({
    required CmsObjectValue cmsObjectValue,
    String? id,
    String? imageUrl,
  }) {
    return Article(
      id: id ?? cmsObjectValue.id as String,
      title: cmsObjectValue.getAttributValueByAttributId('Title'),
      description: cmsObjectValue.getAttributValueByAttributId('Description'),
      imageUrl: imageUrl ?? cmsObjectValue.getAttributValueByAttributId<ImageValue>('Image').imageUrl,
      timestamp: cmsObjectValue.getAttributValueByAttributId('Timestamp'),
      isActive: cmsObjectValue.getAttributValueByAttributId('IsActive'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'timestamp': timestamp.toIso8601String(),
      'isActive': isActive,
    };
  }

  factory Article.fromJson(Map<String, dynamic> map) {
    return Article(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      imageUrl: map['imageUrl'] as String?,
      timestamp: DateTime.parse(map['timestamp']),
      isActive: map['isActive'] as bool,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Article &&
        other.id == id &&
        other.title == title &&
        other.description == description &&
        other.imageUrl == imageUrl &&
        other.timestamp == timestamp &&
        other.isActive == isActive;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        description.hashCode ^
        imageUrl.hashCode ^
        timestamp.hashCode ^
        isActive.hashCode;
  }
}
