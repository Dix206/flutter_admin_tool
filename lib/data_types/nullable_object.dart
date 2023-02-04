import 'package:equatable/equatable.dart';

class NullableObject<T extends Object> extends Equatable {
  final T? value;

  const NullableObject([this.value]);
  
  @override
  List<Object?> get props => [value];
}
