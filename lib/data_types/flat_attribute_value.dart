import 'package:equatable/equatable.dart';

class FlatAttributeValue<T extends Object> extends Equatable {
  /// This id must match the id from the [FlatAttributeStructure] where this [FlatAttributeValue] belongs to
  final String id;
  final T? value;

  const FlatAttributeValue({
    required this.id,
    required this.value,
  });

  @override
  List<Object?> get props => [id, value];

  @override
  bool get stringify => true;
}
