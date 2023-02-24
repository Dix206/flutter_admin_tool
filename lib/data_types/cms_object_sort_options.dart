import 'package:equatable/equatable.dart';

class CmsObjectSortOptions extends Equatable {
  final String attributeId;
  final bool ascending;

  const CmsObjectSortOptions({
    required this.attributeId,
    required this.ascending,
  });

  @override
  List<Object?> get props => [
        attributeId,
        ascending,
      ];
}
