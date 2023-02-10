import 'package:equatable/equatable.dart';

class CmsObjectSortOptions extends Equatable {
  final String attributId;
  final bool ascending;

  const CmsObjectSortOptions({
    required this.attributId,
    required this.ascending,
  });

  @override
  List<Object?> get props => [
        attributId,
        ascending,
      ];
}
