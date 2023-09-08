import 'package:flutter_admin_tool/flat.dart';

class Article {
  final String id;
  final String title;
  final String description;
  final String? imageId;
  final DateTime timestamp;
  final bool isActive;
  final String? authorId;

  Article({
    required this.id,
    required this.title,
    required this.description,
    required this.imageId,
    required this.timestamp,
    required this.isActive,
    required this.authorId,
  });

  FlatObjectValue toFlatObjectValue({
    // required Map<String, String> authHeaders,
    required Author? author,
  }) {
    return FlatObjectValue(
      id: id,
      values: [
        FlatAttributeValue(id: 'id', value: id),
        FlatAttributeValue(id: 'title', value: title),
        FlatAttributeValue(id: 'description', value: description),
        const FlatAttributeValue(
          id: 'image',
          value: null,
          // value: FlatFileValue(
          //   url: imageId != null
          //       ? '$appwriteHost/storage/buckets/articles/files/$imageId/view?project=$appwriteProjectId'
          //       : null,
          //   data: null,
          //   fileName: null,
          //   authHeaders: authHeaders,
          //   wasDeleted: false,
          // ),
        ),
        FlatAttributeValue(id: 'timestamp', value: timestamp),
        FlatAttributeValue(id: 'isActive', value: isActive),
        FlatAttributeValue(id: 'author', value: author),
      ],
    );
  }

  factory Article.fromFlatObjectValue({
    required FlatObjectValue flatObjectValue,
    String? id,
    required String? imageId,
  }) {
    return Article(
      id: id ?? flatObjectValue.id as String,
      title: flatObjectValue.getAttributeValueByAttributeId('title'),
      description:
          flatObjectValue.getAttributeValueByAttributeId('description'),
      imageId: imageId,
      timestamp: flatObjectValue.getAttributeValueByAttributeId('timestamp'),
      isActive: flatObjectValue.getAttributeValueByAttributeId('isActive'),
      authorId:
          (flatObjectValue.getAttributeValueByAttributeId('author') as Author?)
              ?.id,
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
      'authorId': authorId,
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
      authorId: map['authorId'] as String?,
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
        other.authorId == authorId &&
        other.isActive == isActive;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        description.hashCode ^
        imageId.hashCode ^
        timestamp.hashCode ^
        authorId.hashCode ^
        isActive.hashCode;
  }
}

class Author {
  final String id;
  final String name;

  Author({
    required this.id,
    required this.name,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Author && other.id == id && other.name == name;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }

  factory Author.fromJson(Map<String, dynamic> map) {
    return Author(
      id: map['id'] as String,
      name: map['name'] as String,
    );
  }
}
