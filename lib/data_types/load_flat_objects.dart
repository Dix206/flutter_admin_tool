import 'package:equatable/equatable.dart';
import 'package:flutter_admin_tool/data_types/flat_object_sort_options.dart';
import 'package:flutter_admin_tool/data_types/flat_object_value.dart';
import 'package:flutter_admin_tool/data_types/flat_result.dart';

typedef OnLoadFlatObjectsOffset = Future<FlatResult<FlatOffsetObjectValueList>> Function({
  required int page,
  required String? searchQuery,
  required FlatObjectSortOptions? sortOptions,
});
typedef OnLoadFlatObjectsCurser = Future<FlatResult<FlatCurserObjectValueList>> Function({
  required String? lastLoadedObjectId,
  required String? searchQuery,
  required FlatObjectSortOptions? sortOptions,
});

/// This class is used to load define the loading strategy for flat object values.
/// It can either be loaded by offset or by curser.
class LoadFlatObjects extends Equatable {
  final OnLoadFlatObjectsOffset? offsetLoading;
  final OnLoadFlatObjectsCurser? curserLoading;

  const LoadFlatObjects._({
    required this.offsetLoading,
    required this.curserLoading,
  });

  factory LoadFlatObjects.offset(OnLoadFlatObjectsOffset offsetLoading) => LoadFlatObjects._(
        offsetLoading: offsetLoading,
        curserLoading: null,
      );

  factory LoadFlatObjects.curser(OnLoadFlatObjectsCurser curserLoading) => LoadFlatObjects._(
        offsetLoading: null,
        curserLoading: curserLoading,
      );

  S fold<S>({
    required S Function(OnLoadFlatObjectsOffset offsetLoading) onOffsetLoading,
    required S Function(OnLoadFlatObjectsCurser curserLoading) onCurserLoading,
  }) {
    if (offsetLoading != null) {
      return onOffsetLoading(offsetLoading!);
    } else {
      return onCurserLoading(curserLoading!);
    }
  }

  @override
  List<Object?> get props => [offsetLoading, curserLoading];
}
