import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cms/data_types/cms_object_structure.dart';
import 'package:flutter_cms/data_types/cms_object_sort_options.dart';
import 'package:flutter_cms/data_types/cms_object_value.dart';
import 'package:flutter_cms/data_types/nullable_object.dart';

class CmsObjectOverviewViewModelProvider extends StatefulWidget {
  final CmsObjectStructure cmsObject;
  final Widget Function(BuildContext) childBuilder;

  const CmsObjectOverviewViewModelProvider({
    Key? key,
    required this.cmsObject,
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
  final Function(CmsObjectOverviewState) onNotifyListener;
  CmsObjectOverviewState state = const CmsObjectOverviewState();

  CmsObjectOverviewViewModel({
    required this.cmsObject,
    required this.onNotifyListener,
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
      searchQuery: null,
      lastLoadedCmsObjectId: null,
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
        hasMoreItems: cmsObjectValueList.hasMoreItems,
      ),
    );
    onNotifyListener(state);
  }

  Future<void> loadMoreItems() async {
    if (state.isLoadingMoreItems || !state.hasMoreItems) return;

    state = state.copyWith(
      isLoadingMoreItems: true,
      loadMoreItemsError: const NullableObject(),
    );
    onNotifyListener(state);

    final result = await cmsObject.onLoadCmsObjects(
      searchQuery: null,
      lastLoadedCmsObjectId: state.cmsObjectValues!.last.id,
      sortOptions: const CmsObjectSortOptions(
        attributName: "id",
        ascending: true,
      ),
    );

    state = result.fold(
      onError: (errorMessage) => state.copyWith(
        isLoadingMoreItems: false,
        loadMoreItemsError: NullableObject(errorMessage),
      ),
      onSuccess: (cmsObjectValueList) => state.copyWith(
        isLoadingMoreItems: false,
        cmsObjectValues: NullableObject([
          ...state.cmsObjectValues!,
          ...cmsObjectValueList.cmsObjectValues,
        ]),
        hasMoreItems: cmsObjectValueList.hasMoreItems,
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
  final bool hasMoreItems;
  final bool isLoadingMoreItems;
  final String? loadMoreItemsError;

  const CmsObjectOverviewState({
    this.loadingError,
    this.cmsObjectValues,
    this.hasMoreItems = true,
    this.isLoadingMoreItems = false,
    this.loadMoreItemsError,
  });

  CmsObjectOverviewState copyWith({
    NullableObject<String>? loadingError,
    NullableObject<List<CmsObjectValue>>? cmsObjectValues,
    bool? hasMoreItems,
    bool? isLoadingMoreItems,
    NullableObject<String>? loadMoreItemsError,
  }) =>
      CmsObjectOverviewState(
        loadingError: loadingError?.value ?? this.loadingError,
        cmsObjectValues: cmsObjectValues?.value ?? this.cmsObjectValues,
        hasMoreItems: hasMoreItems ?? this.hasMoreItems,
        isLoadingMoreItems: isLoadingMoreItems ?? this.isLoadingMoreItems,
        loadMoreItemsError: loadMoreItemsError?.value ?? this.loadMoreItemsError,
      );

  @override
  List<Object?> get props => [
        loadingError,
        cmsObjectValues,
        hasMoreItems,
        isLoadingMoreItems,
        loadMoreItemsError,
      ];
}
