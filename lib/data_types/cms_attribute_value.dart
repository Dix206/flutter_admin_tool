import 'package:equatable/equatable.dart';

class CmsAttributeValue<T extends Object> extends Equatable {
  /// This id must match the id from the [CmsAttributeStructure] where this [CmsAttributeValue] belongs to
  final String id;
  final T? value;

  const CmsAttributeValue({
    required this.id,
    required this.value,
  });

  @override
  List<Object?> get props => [id, value];

  @override
  bool get stringify => true;
}
