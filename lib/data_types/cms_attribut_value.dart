import 'package:equatable/equatable.dart';

class CmsAttributValue<T extends Object> extends Equatable {
  /// This name must match the name from the [CmsAttribut] where this [CmsAttributValue] belongs to
  final String name;
  final T? value;

  const CmsAttributValue({
    required this.name,
    required this.value,
  });

  @override
  List<Object?> get props => [name, value];

  @override
  bool get stringify => true;
}
