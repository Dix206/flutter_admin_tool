import 'dart:typed_data';

import 'package:equatable/equatable.dart';

class CmsFileValue extends Equatable {
  final Uint8List? data;
  final String? fileName;
  final String? url;
  final Map<String, String>? authHeaders;
  final bool wasDeleted;

  const CmsFileValue({
    required this.data,
    required this.fileName,
    required this.url,
    required this.authHeaders,
    required this.wasDeleted,
  });

  @override
  List<Object?> get props => [data, fileName, url, authHeaders, wasDeleted];
}