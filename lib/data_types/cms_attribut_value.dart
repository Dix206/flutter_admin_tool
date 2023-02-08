import 'package:equatable/equatable.dart';

class CmsAttributValue<T extends Object> extends Equatable {
  /// This id must match the id from the [CmsAttribut] where this [CmsAttributValue] belongs to
  final String id;
  final T? value;

  const CmsAttributValue({
    required this.id,
    required this.value,
  });

  @override
  List<Object?> get props => [id, value];

  @override
  bool get stringify => true;
}
