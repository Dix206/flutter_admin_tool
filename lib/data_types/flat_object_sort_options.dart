import 'package:equatable/equatable.dart';

class FlatObjectSortOptions extends Equatable {
  final String attributeId;
  final bool ascending;

  const FlatObjectSortOptions({
    required this.attributeId,
    required this.ascending,
  });

  @override
  List<Object?> get props => [
        attributeId,
        ascending,
      ];
}
