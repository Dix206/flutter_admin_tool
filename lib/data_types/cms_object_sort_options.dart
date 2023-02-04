import 'package:equatable/equatable.dart';

class CmsObjectSortOptions extends Equatable {
  final String attributName;
  final bool ascending;

  const CmsObjectSortOptions({
    required this.attributName,
    required this.ascending,
  });

  @override
  List<Object?> get props => [
        attributName,
        ascending,
      ];
}
