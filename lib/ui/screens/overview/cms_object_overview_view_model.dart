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
  final CmsObjectSortOptions? sortOptions;
  final Widget Function(BuildContext) childBuilder;
  final Function(CmsObjectOverviewState) onStateUpdate;

  const CmsObjectOverviewViewModelProvider({
    Key? key,
    required this.cmsObject,
    required this.searchQuery,
    required this.page,
    required this.childBuilder,
    required this.onStateUpdate,
    required this.sortOptions,
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

  Widget? _oldViewModel;

  @override
  Widget build(BuildContext context) {
    if (_oldViewModel == null || _oldViewModel!.key != ValueKey(widget.cmsObject)) {
      _oldViewModel = CmsObjectOverviewViewModel(
        key: ValueKey(widget.cmsObject),
        cmsObject: widget.cmsObject,
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
    }

    return _oldViewModel!;
  }
}

// ignore: must_be_immutable
class CmsObjectOverviewViewModel extends InheritedWidget {
  final CmsObjectStructure cmsObject;
  final String? searchQuery;
  final int page;
  final Function(CmsObjectOverviewState) onNotifyListener;
  final CmsObjectSortOptions? sortOptions;
  CmsObjectOverviewState state = const CmsObjectOverviewState();

  CmsObjectOverviewViewModel({
    required this.cmsObject,
    required this.onNotifyListener,
    required this.searchQuery,
    required this.page,
    required this.sortOptions,
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
      sortOptions: sortOptions,
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
