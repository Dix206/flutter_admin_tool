import 'package:flutter_cms/data_types/cms_attribut_value.dart';
import 'package:flutter_cms/data_types/cms_object_value.dart';

class ArticleAppwriteDto {
  final String id;
  final String title;
  final String description;
  final String? imageId;
  final DateTime timestamp;
  final bool isActive;

  ArticleAppwriteDto({
    required this.id,
    required this.title,
    required this.description,
    required this.imageId,
    required this.timestamp,
    required this.isActive,
  });

  CmsObjectValue toCmsObjectValue() {
    return CmsObjectValue(
      id: id,
      values: [
        CmsAttributValue(name: 'id', value: id),
        CmsAttributValue(name: 'title', value: title),
        CmsAttributValue(name: 'description', value: description),
        // CmsAttributValue(name: 'imageId', value: imageId), // TODO
        CmsAttributValue(name: 'timestamp', value: timestamp),
        CmsAttributValue(name: 'isActive', value: isActive),
      ],
    );
  }

  factory ArticleAppwriteDto.fromCmsObjectValue({
    required CmsObjectValue cmsObjectValue,
    String? id,
  }) {
    return ArticleAppwriteDto(
      id: id ?? cmsObjectValue.id as String,
      title: cmsObjectValue.getValueByName('Title') as String,
      description: cmsObjectValue.getValueByName('Description') as String,
      imageId: cmsObjectValue.getValueByName('ImageId') as String?,
      timestamp: DateTime.now(), // TODO
      isActive: cmsObjectValue.getValueByName('IsActive') as bool,
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

  factory ArticleAppwriteDto.fromJson(Map<String, dynamic> map) {
    return ArticleAppwriteDto(
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

    return other is ArticleAppwriteDto &&
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
