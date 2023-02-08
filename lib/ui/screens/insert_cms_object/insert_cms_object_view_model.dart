import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'package:flutter_cms/data_types/cms_attribut_value.dart';
import 'package:flutter_cms/data_types/cms_object_structure.dart';
import 'package:flutter_cms/data_types/cms_object_value.dart';
import 'package:flutter_cms/data_types/nullable_object.dart';
import 'package:flutter_cms/data_types/result.dart';

class InsertCmsObjectViewModelProvider extends StatefulWidget {
  final CmsObjectStructure cmsObject;
  final String? existingCmsObjectValueId;
  final Widget Function(BuildContext) childBuilder;
  final Function(InsertCmsObjectState) onStateUpdate;

  const InsertCmsObjectViewModelProvider({
    Key? key,
    required this.cmsObject,
    required this.existingCmsObjectValueId,
    required this.childBuilder,
    required this.onStateUpdate,
  }) : super(key: key);

  @override
  State createState() => _InsertCmsObjectViewModelProviderState();
}

class _InsertCmsObjectViewModelProviderState extends State<InsertCmsObjectViewModelProvider> {
  final ValueNotifier<InsertCmsObjectState?> _state = ValueNotifier(null);

  @override
  void dispose() {
    _state.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InsertCmsObjectViewModel(
      cmsObject: widget.cmsObject,
      existingCmsObjectValueId: widget.existingCmsObjectValueId,
      onNotifyListener: (state) {
        if (!mounted) return;
        if (_state.value != state) widget.onStateUpdate(state);
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
class InsertCmsObjectViewModel extends InheritedWidget {
  final CmsObjectStructure cmsObject;
  final String? existingCmsObjectValueId;
  final Function(InsertCmsObjectState) onNotifyListener;
  InsertCmsObjectState state = InsertCmsObjectLoadingState();

  InsertCmsObjectViewModel({
    required this.cmsObject,
    required this.existingCmsObjectValueId,
    required this.onNotifyListener,
    required super.child,
    super.key,
  }) {
    init();
  }

  static InsertCmsObjectViewModel of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<InsertCmsObjectViewModel>()!;
  }

  Future<void> init() async {
    state = InsertCmsObjectLoadingState();
    onNotifyListener(state);

    if (existingCmsObjectValueId == null) {
      state = InsertCmsObjectInitState(
        currentCmsObjectValue: cmsObject.toEmptyCmsObjectValue(),
      );
      onNotifyListener(state);
      return;
    }

    final result = await cmsObject.loadCmsObjectById(existingCmsObjectValueId!);

    state = result.fold(
      onError: (errorMessage) => InsertCmsObjectFailureState(errorMessage),
      onSuccess: (cmsObjectValue) => InsertCmsObjectInitState(
        currentCmsObjectValue: cmsObjectValue,
      ),
    );
    onNotifyListener(state);
  }

  void updateAttributValue({
    required String id,
    required Object? value,
  }) {
    if (state is! InsertCmsObjectInitState) return;
    final initState = state as InsertCmsObjectInitState;

    state = initState.copyWith(
      currentCmsObjectValue: initState.currentCmsObjectValue.copyWithNewValue(
        CmsAttributValue(
          id: id,
          value: value,
        ),
      ),
    );
    onNotifyListener(state);
  }

  Future<void> insertObject() async {
    if (state is! InsertCmsObjectInitState) return;
    final initState = state as InsertCmsObjectInitState;

    if (!cmsObject.isCmsObjectValueValid(initState.currentCmsObjectValue)) {
      state = initState.copyWith(
        failure: const NullableObject("Bitte überprüfe deine Eingaben"),
      );
      onNotifyListener(state);
      state = initState.copyWith(
        shouldDisplayValidationErrors: true,
        failure: const NullableObject(),
      );
      onNotifyListener(state);
      return;
    }

    state = initState.copyWith(isInserting: true);
    onNotifyListener(state);

    final Result result;

    if (existingCmsObjectValueId != null) {
      result = cmsObject.onUpdateCmsObject != null
          ? await cmsObject.onUpdateCmsObject!(initState.currentCmsObjectValue)
          : Result.success(const Unit());
    } else {
      result = cmsObject.onCreateCmsObject != null
          ? await cmsObject.onCreateCmsObject!(initState.currentCmsObjectValue)
          : Result.success(const Unit());
    }

    result.fold(
      onError: (errorMessage) {
        state = initState.copyWith(
          failure: NullableObject(errorMessage),
        );
        onNotifyListener(state);
        state = initState.copyWith(
          isInserting: false,
          failure: const NullableObject(),
        );
        onNotifyListener(state);
      },
      onSuccess: (unit) {
        state = initState.copyWith(
          isInserting: false,
          isInsertSuccessfull: true,
        );
        onNotifyListener(state);
      },
    );
  }

  @override
  bool updateShouldNotify(InsertCmsObjectViewModel oldWidget) {
    return state != oldWidget.state;
  }
}

abstract class InsertCmsObjectState {}

class InsertCmsObjectLoadingState extends InsertCmsObjectState {}

class InsertCmsObjectFailureState extends InsertCmsObjectState {
  final String failure;

  InsertCmsObjectFailureState(this.failure);
}

class InsertCmsObjectInitState extends InsertCmsObjectState with EquatableMixin {
  final CmsObjectValue currentCmsObjectValue;
  final bool shouldDisplayValidationErrors;
  final bool isInserting;
  final bool isInsertSuccessfull;
  final String? failure;

  InsertCmsObjectInitState({
    required this.currentCmsObjectValue,
    this.shouldDisplayValidationErrors = false,
    this.isInserting = false,
    this.isInsertSuccessfull = false,
    this.failure,
  });

  @override
  List<Object?> get props {
    return [
      currentCmsObjectValue,
      shouldDisplayValidationErrors,
      isInserting,
      isInsertSuccessfull,
      failure,
    ];
  }

  InsertCmsObjectInitState copyWith({
    CmsObjectValue? currentCmsObjectValue,
    bool? shouldDisplayValidationErrors,
    bool? isInserting,
    bool? isInsertSuccessfull,
    NullableObject<String>? failure,
  }) {
    return InsertCmsObjectInitState(
      currentCmsObjectValue: currentCmsObjectValue ?? this.currentCmsObjectValue,
      shouldDisplayValidationErrors: shouldDisplayValidationErrors ?? this.shouldDisplayValidationErrors,
      isInserting: isInserting ?? this.isInserting,
      isInsertSuccessfull: isInsertSuccessfull ?? this.isInsertSuccessfull,
      failure: failure == null ? this.failure : failure.value,
    );
  }
}
