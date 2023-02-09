import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'package:flutter_cms/data_types/cms_object_sort_options.dart';
import 'package:flutter_cms/data_types/cms_object_structure.dart';
import 'package:flutter_cms/data_types/cms_object_value.dart';
import 'package:flutter_cms/data_types/nullable_object.dart';

class CmsObjectOverviewViewModelProvider extends StatefulWidget {
  final CmsObjectStructure cmsObject;
  final String? searchQuery;
  final int page;
  final Widget Function(BuildContext) childBuilder;

  const CmsObjectOverviewViewModelProvider({
    Key? key,
    required this.cmsObject,
        required this.searchQuery,
    required this.page,
    required this.childBuilder,
  }) : super(key: key);

  @override
  State createState() => _CmsObjectOverviewViewModelProviderState();
}

class _CmsObjectOverviewViewModelProviderState extends State<CmsObjectOverviewViewModelProvider> {
  final ValueNotifier<CmsObjectOverviewState?> _state = ValueNotifier(null);

  @override
  void dispose() {
    _state.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CmsObjectOverviewViewModel(
      cmsObject: widget.cmsObject,
      searchQuery: widget.searchQuery,
      page: widget.page,
      onNotifyListener: (state) {
        if (!mounted) return;
        _state.value = state;
      },
      child: ValueListenableBuilder(
        valueListenable: _state,
        builder: (context, value, child) => widget.childBuilder(context),
      ),
    );
  }
}

// ignore: must_be_immutable
class CmsObjectOverviewViewModel extends InheritedWidget {
  final CmsObjectStructure cmsObject;
  final String? searchQuery;
  final int page;
  final Function(CmsObjectOverviewState) onNotifyListener;
  CmsObjectOverviewState state = const CmsObjectOverviewState();

  CmsObjectOverviewViewModel({
    required this.cmsObject,
    required this.onNotifyListener,
    required this.searchQuery,
    required this.page,
    required super.child,
    super.key,
  }) {
    init();
  }

  static CmsObjectOverviewViewModel of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<CmsObjectOverviewViewModel>()!;
  }

  Future<void> init() async {
    state = state.copyWith(
      loadingError: const NullableObject(),
    );
    onNotifyListener(state);

    final result = await cmsObject.onLoadCmsObjects(
      searchQuery: searchQuery,
      page: page,
      sortOptions: const CmsObjectSortOptions(
        attributName: "id",
        ascending: true,
      ),
    );

    state = result.fold(
      onError: (errorMessage) => state.copyWith(
        loadingError: NullableObject(errorMessage),
      ),
      onSuccess: (cmsObjectValueList) => state.copyWith(
        cmsObjectValues: NullableObject(cmsObjectValueList.cmsObjectValues),
        totalPages: cmsObjectValueList.overallPageCount,
      ),
    );
    onNotifyListener(state);
  }

  // Future<void> loadMoreItems() async {
  //   final result = await cmsObject.onLoadCmsObjects(
  //     searchQuery: state.searchString,
  //     page: state.cmsObjectValues!.last.id,
  //     sortOptions: const CmsObjectSortOptions(
  //       attributName: "id",
  //       ascending: true,
  //     ),
  //   );

  //   state = result.fold(
  //     onError: (errorMessage) => state.copyWith(
  //       isLoadingMoreItems: false,
  //       loadMoreItemsError: NullableObject(errorMessage),
  //     ),
  //     onSuccess: (cmsObjectValueList) => state.copyWith(
  //       isLoadingMoreItems: false,
  //       cmsObjectValues: NullableObject([
  //         ...state.cmsObjectValues!,
  //         ...cmsObjectValueList.cmsObjectValues,
  //       ]),
  //       hasMoreItems: cmsObjectValueList.hasMoreItems,
  //     ),
  //   );
  //   onNotifyListener(state);
  // }

  DateTime _lastSearchStringChange = DateTime.now();

  // Future<void> setSearchString(String searchString) async {
  //   if (searchString == state.searchString) return;

  //   final thisSearchStringChange = DateTime.now();
  //   _lastSearchStringChange = thisSearchStringChange;
  //   await Future.delayed(const Duration(milliseconds: 1000));
  //   if (_lastSearchStringChange != thisSearchStringChange) return;

  //   state = state.copyWith(
  //     searchString: NullableObject(searchString.trim().isEmpty ? null : searchString),
  //   );

  //   final result = await cmsObject.onLoadCmsObjects(
  //     searchQuery: state.searchString,
  //     lastLoadedCmsObjectId: null,
  //     sortOptions: const CmsObjectSortOptions(
  //       attributName: "id",
  //       ascending: true,
  //     ),
  //   );

  //   state = result.fold(
  //     onError: (errorMessage) => state.copyWith(
  //       loadingError: NullableObject(errorMessage),
  //     ),
  //     onSuccess: (cmsObjectValueList) => state.copyWith(
  //       cmsObjectValues: NullableObject(cmsObjectValueList.cmsObjectValues),
  //       hasMoreItems: cmsObjectValueList.hasMoreItems,
  //     ),
  //   );
  //   onNotifyListener(state);
  // }

  @override
  bool updateShouldNotify(CmsObjectOverviewViewModel oldWidget) {
    return state != oldWidget.state;
  }
}

class CmsObjectOverviewState extends Equatable {
  final String? loadingError;
  final List<CmsObjectValue>? cmsObjectValues;
  final int totalPages;

  const CmsObjectOverviewState({
    this.loadingError,
    this.cmsObjectValues,
    this.totalPages = 1,
  });

  CmsObjectOverviewState copyWith({
    NullableObject<String>? loadingError,
    NullableObject<List<CmsObjectValue>>? cmsObjectValues,
    int? totalPages,
  }) {
    return CmsObjectOverviewState(
      loadingError: loadingError == null ? this.loadingError : loadingError.value,
      cmsObjectValues: cmsObjectValues == null ? this.cmsObjectValues : cmsObjectValues.value,
      totalPages: totalPages ?? this.totalPages,
    );
  }

  @override
  List<Object?> get props {
    return [
      loadingError,
      cmsObjectValues,
      totalPages,
    ];
  }
}
