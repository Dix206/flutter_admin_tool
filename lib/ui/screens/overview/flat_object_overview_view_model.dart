import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'package:flat/data_types/flat_object_sort_options.dart';
import 'package:flat/data_types/flat_object_structure.dart';
import 'package:flat/data_types/flat_object_value.dart';
import 'package:flat/data_types/nullable_object.dart';

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

    final result = await flatObject.onLoadFlatObjects(
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

  const FlatObjectOverviewState({
    this.loadingError,
    this.flatObjectValues,
    this.totalPages = 1,
  });

  FlatObjectOverviewState copyWith({
    NullableObject<String>? loadingError,
    NullableObject<List<FlatObjectValue>>? flatObjectValues,
    int? totalPages,
  }) {
    return FlatObjectOverviewState(
      loadingError: loadingError == null ? this.loadingError : loadingError.value,
      flatObjectValues: flatObjectValues == null ? this.flatObjectValues : flatObjectValues.value,
      totalPages: totalPages ?? this.totalPages,
    );
  }

  @override
  List<Object?> get props {
    return [
      loadingError,
      flatObjectValues,
      totalPages,
    ];
  }
}
