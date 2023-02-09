import 'package:example/constants.dart';
import 'package:flutter_cms/data_types/attribut_implementations/cms_attribut_image/cms_attribut_image.dart';
import 'package:flutter_cms/data_types/cms_attribut_value.dart';
import 'package:flutter_cms/data_types/cms_object_value.dart';

class Article {
  final String id;
  final String title;
  final String description;
  final String? imageId;
  final DateTime timestamp;
  final bool isActive;

  Article({
    required this.id,
    required this.title,
    required this.description,
    required this.imageId,
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
            imageUrl: imageId != null
                ? '$appwriteHost/storage/buckets/articles/files/$imageId/view?project=$appwriteProjectId'
                : null,
            imageData: null,
            headers: authHeaders,
            wasDeleted: false,
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
    required String? imageId,
  }) {
    return Article(
      id: id ?? cmsObjectValue.id as String,
      title: cmsObjectValue.getAttributValueByAttributId('Title'),
      description: cmsObjectValue.getAttributValueByAttributId('Description'),
      imageId: imageId,
      timestamp: cmsObjectValue.getAttributValueByAttributId('Timestamp'),
      isActive: cmsObjectValue.getAttributValueByAttributId('IsActive'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'imageId': imageId,
      'timestamp': timestamp.toIso8601String(),
      'isActive': isActive,
    };
  }

  factory Article.fromJson(Map<String, dynamic> map) {
    return Article(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      imageId: map['imageId'] as String?,
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
        other.imageId == imageId &&
        other.timestamp == timestamp &&
        other.isActive == isActive;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        description.hashCode ^
        imageId.hashCode ^
        timestamp.hashCode ^
        isActive.hashCode;
  }
}
