import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'package:flutter_admin_tool/data_types/flat_object_sort_options.dart';
import 'package:flutter_admin_tool/data_types/flat_object_structure.dart';
import 'package:flutter_admin_tool/data_types/flat_object_value.dart';
import 'package:flutter_admin_tool/data_types/nullable_object.dart';

class FlatObjectOverviewViewModelProvider extends StatefulWidget {
  final FlatObjectStructure flatObject;
  final String? searchQuery;
  final int page;
  final FlatObjectSortOptions? sortOptions;
  final Widget Function(BuildContext) childBuilder;
  final Function(FlatObjectOverviewState) onStateUpdate;

  const FlatObjectOverviewViewModelProvider({
    Key? key,
    required this.flatObject,
    required this.searchQuery,
    required this.page,
    required this.childBuilder,
    required this.onStateUpdate,
    required this.sortOptions,
  }) : super(key: key);

  @override
  State createState() => _FlatObjectOverviewViewModelProviderState();
}

class _FlatObjectOverviewViewModelProviderState extends State<FlatObjectOverviewViewModelProvider> {
  final ValueNotifier<FlatObjectOverviewState?> _state = ValueNotifier(null);

  @override
  void dispose() {
    _state.dispose();
    super.dispose();
  }

  Widget? _oldViewModel;
  String? _oldSearchQuery;
  int? _oldPage;
  FlatObjectSortOptions? _oldSortOptions;
  FlatObjectStructure? _oldFlatObject;

  @override
  Widget build(BuildContext context) {
    if (_oldViewModel != null &&
        _oldFlatObject?.id == widget.flatObject.id &&
        _oldSearchQuery == widget.searchQuery &&
        _oldPage == widget.page &&
        _oldSortOptions == widget.sortOptions) {
      return _oldViewModel!;
    }

    _oldSearchQuery = widget.searchQuery;
    _oldPage = widget.page;
    _oldSortOptions = widget.sortOptions;
    _oldFlatObject = widget.flatObject;

    _oldViewModel = FlatObjectOverviewViewModel(
      flatObject: widget.flatObject,
      searchQuery: widget.searchQuery,
      page: widget.page,
      onNotifyListener: (state) {
        if (!mounted || state == _state.value) return;
        widget.onStateUpdate(state);
        _state.value = state;
      },
      sortOptions: widget.sortOptions,
      child: ValueListenableBuilder(
        valueListenable: _state,
        builder: (context, value, child) => widget.childBuilder(context),
      ),
    );

    return _oldViewModel!;
  }
}

// ignore: must_be_immutable
class FlatObjectOverviewViewModel extends InheritedWidget {
  final FlatObjectStructure flatObject;
  final String? searchQuery;
  final int page;
  final Function(FlatObjectOverviewState) onNotifyListener;
  final FlatObjectSortOptions? sortOptions;
  FlatObjectOverviewState state = const FlatObjectOverviewState();

  FlatObjectOverviewViewModel({
    required this.flatObject,
    required this.onNotifyListener,
    required this.searchQuery,
    required this.page,
    required this.sortOptions,
    required super.child,
    super.key,
  }) {
    init();
  }

  static FlatObjectOverviewViewModel of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<FlatObjectOverviewViewModel>()!;
  }

  Future<void> init() async {
    state = state.copyWith(
      loadingError: const NullableObject(),
    );
    onNotifyListener(state);

    await flatObject.onLoadFlatObjects.fold(
      onOffsetLoading: (function) async {
        final result = await function(
          searchQuery: searchQuery,
          page: page,
          sortOptions: sortOptions,
        );

        state = result.fold(
          onError: (errorMessage) => state.copyWith(
            loadingError: NullableObject(errorMessage),
          ),
          onSuccess: (flatObjectValueList) => state.copyWith(
            flatObjectValues: NullableObject(flatObjectValueList.flatObjectValues),
            totalPages: flatObjectValueList.overallPageCount,
          ),
        );
        onNotifyListener(state);
      },
      onCurserLoading: (function) async {
        final result = await function(
          searchQuery: searchQuery,
          lastLoadedObjectId: null,
          sortOptions: sortOptions,
        );

        state = result.fold(
          onError: (errorMessage) => state.copyWith(
            loadingError: NullableObject(errorMessage),
          ),
          onSuccess: (flatCurserObjectValueList) => state.copyWith(
            flatObjectValues: NullableObject(flatCurserObjectValueList.flatObjectValues),
            hasMoreItems: flatCurserObjectValueList.hasMoreItems,
          ),
        );
        onNotifyListener(state);
      },
    );
  }

  Future<void> loadMoreItems() async {
    if (state.isLoadingMoreItems || !state.hasMoreItems) return;
    state = state.copyWith(
      isLoadingMoreItems: true,
      loadMoreItemsError: const NullableObject(),
    );
    onNotifyListener(state);

    final result = await flatObject.onLoadFlatObjects.curserLoading!.call(
      searchQuery: searchQuery,
      lastLoadedObjectId: state.flatObjectValues?.last.id,
      sortOptions: sortOptions,
    );

    state = result.fold(
      onError: (errorMessage) => state.copyWith(
        loadMoreItemsError: NullableObject(errorMessage),
        isLoadingMoreItems: false,
      ),
      onSuccess: (flatCurserObjectValueList) => state.copyWith(
        flatObjectValues: NullableObject(
          [
            ...state.flatObjectValues!,
            ...flatCurserObjectValueList.flatObjectValues,
          ],
        ),
        hasMoreItems: flatCurserObjectValueList.hasMoreItems,
        isLoadingMoreItems: false,
      ),
    );
    onNotifyListener(state);
  }

  @override
  bool updateShouldNotify(FlatObjectOverviewViewModel oldWidget) {
    return state != oldWidget.state;
  }
}

class FlatObjectOverviewState extends Equatable {
  final String? loadingError;
  final List<FlatObjectValue>? flatObjectValues;
  final int totalPages;
  final bool isLoadingMoreItems;
  final String? loadMoreItemsError;
  final bool hasMoreItems;

  const FlatObjectOverviewState({
    this.loadingError,
    this.flatObjectValues,
    this.totalPages = 1,
    this.isLoadingMoreItems = false,
    this.loadMoreItemsError,
    this.hasMoreItems = false,
  });

  FlatObjectOverviewState copyWith({
    NullableObject<String>? loadingError,
    NullableObject<List<FlatObjectValue>>? flatObjectValues,
    int? totalPages,
    bool? isLoadingMoreItems,
    NullableObject<String>? loadMoreItemsError,
    bool? hasMoreItems,
  }) {
    return FlatObjectOverviewState(
      loadingError: loadingError == null ? this.loadingError : loadingError.value,
      flatObjectValues: flatObjectValues == null ? this.flatObjectValues : flatObjectValues.value,
      totalPages: totalPages ?? this.totalPages,
      isLoadingMoreItems: isLoadingMoreItems ?? this.isLoadingMoreItems,
      loadMoreItemsError: loadMoreItemsError == null ? this.loadMoreItemsError : loadMoreItemsError.value,
      hasMoreItems: hasMoreItems ?? this.hasMoreItems,
    );
  }

  @override
  List<Object?> get props {
    return [
      loadingError,
      flatObjectValues,
      totalPages,
      isLoadingMoreItems,
      loadMoreItemsError,
      hasMoreItems,
    ];
  }
}
