import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'package:flat/data_types/flat_attribute_value.dart';
import 'package:flat/data_types/flat_object_structure.dart';
import 'package:flat/data_types/flat_object_value.dart';
import 'package:flat/data_types/nullable_object.dart';
import 'package:flat/data_types/flat_result.dart';
import 'package:flat/flat_app.dart';

class InsertFlatObjectViewModelProvider extends StatefulWidget {
  final FlatObjectStructure flatObject;
  final String? existingFlatObjectValueId;
  final Widget Function(BuildContext) childBuilder;
  final Function(InsertFlatObjectState) onStateUpdate;

  const InsertFlatObjectViewModelProvider({
    Key? key,
    required this.flatObject,
    required this.existingFlatObjectValueId,
    required this.childBuilder,
    required this.onStateUpdate,
  }) : super(key: key);

  @override
  State createState() => _InsertFlatObjectViewModelProviderState();
}

class _InsertFlatObjectViewModelProviderState extends State<InsertFlatObjectViewModelProvider> {
  final ValueNotifier<InsertFlatObjectState?> _state = ValueNotifier(null);

  @override
  void dispose() {
    _state.dispose();
    super.dispose();
  }

  Widget? _oldViewModel;
  String? _oldExistingFlatObjectValueId;
  FlatObjectStructure? _oldFlatObject;

  @override
  Widget build(BuildContext context) {
    if (_oldViewModel != null &&
        _oldFlatObject?.id == widget.flatObject.id &&
        _oldExistingFlatObjectValueId == widget.existingFlatObjectValueId) {
      return _oldViewModel!;
    }

    _oldExistingFlatObjectValueId = widget.existingFlatObjectValueId;
    _oldFlatObject = widget.flatObject;

    _oldViewModel = InsertFlatObjectViewModel(
      key: ValueKey(widget.flatObject.id),
      flatObject: widget.flatObject,
      existingFlatObjectValueId: widget.existingFlatObjectValueId,
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

    return _oldViewModel!;
  }
}

// ignore: must_be_immutable
class InsertFlatObjectViewModel extends InheritedWidget {
  final FlatObjectStructure flatObject;
  final String? existingFlatObjectValueId;
  final Function(InsertFlatObjectState) onNotifyListener;
  InsertFlatObjectState state = InsertFlatObjectLoadingState();

  InsertFlatObjectViewModel({
    required this.flatObject,
    required this.existingFlatObjectValueId,
    required this.onNotifyListener,
    required super.child,
    super.key,
  }) {
    init();
  }

  static InsertFlatObjectViewModel of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<InsertFlatObjectViewModel>()!;
  }

  Future<void> init() async {
    state = InsertFlatObjectLoadingState();
    onNotifyListener(state);

    if (existingFlatObjectValueId == null) {
      state = InsertFlatObjectInitState(
        currentFlatObjectValue: flatObject.toEmptyFlatObjectValue(),
      );
      onNotifyListener(state);
      return;
    }

    final result = await flatObject.loadFlatObjectById(existingFlatObjectValueId!);

    state = result.fold(
      onError: (errorMessage) => InsertFlatObjectFailureState(errorMessage),
      onSuccess: (flatObjectValue) => InsertFlatObjectInitState(
        currentFlatObjectValue: flatObjectValue,
      ),
    );
    onNotifyListener(state);
  }

  void updateAttributeValue({
    required String id,
    required Object? value,
  }) {
    if (state is! InsertFlatObjectInitState) return;
    final initState = state as InsertFlatObjectInitState;

    state = initState.copyWith(
      currentFlatObjectValue: initState.currentFlatObjectValue.copyWithNewValue(
        FlatAttributeValue(
          id: id,
          value: value,
        ),
      ),
    );
    onNotifyListener(state);
  }

  Future<void> deleteObject() async {
    if (state is! InsertFlatObjectInitState || existingFlatObjectValueId == null || flatObject.onDeleteFlatObject == null) {
      return;
    }
    final initState = state as InsertFlatObjectInitState;

    state = initState.copyWith(isDeleting: true);
    onNotifyListener(state);

    final result = await flatObject.onDeleteFlatObject!(existingFlatObjectValueId!);

    result.fold(
      onError: (errorMessage) {
        state = initState.copyWith(
          failure: NullableObject(errorMessage),
        );
        onNotifyListener(state);
        state = initState.copyWith(
          isDeleting: false,
          failure: const NullableObject(),
        );
        onNotifyListener(state);
      },
      onSuccess: (unit) {
        state = initState.copyWith(
          isDeleting: false,
          isDeletionSuccessfull: true,
        );
        onNotifyListener(state);
      },
    );
  }

  Future<void> insertObject(BuildContext context) async {
    if (state is! InsertFlatObjectInitState) return;
    final initState = state as InsertFlatObjectInitState;

    if (!flatObject.isFlatObjectValueValid(initState.currentFlatObjectValue)) {
      state = initState.copyWith(
        failure: NullableObject(
          FlatApp.getFlatTexts(context).insertFlatObjectInvalidDataMessage,
        ),
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

    final FlatResult result;

    if (existingFlatObjectValueId != null) {
      result = flatObject.onUpdateFlatObject != null
          ? await flatObject.onUpdateFlatObject!(initState.currentFlatObjectValue)
          : FlatResult.success(const Unit());
    } else {
      result = flatObject.onCreateFlatObject != null
          ? await flatObject.onCreateFlatObject!(initState.currentFlatObjectValue)
          : FlatResult.success(const Unit());
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
  bool updateShouldNotify(InsertFlatObjectViewModel oldWidget) {
    return state != oldWidget.state;
  }
}

abstract class InsertFlatObjectState {}

class InsertFlatObjectLoadingState extends InsertFlatObjectState {}

class InsertFlatObjectFailureState extends InsertFlatObjectState {
  final String failure;

  InsertFlatObjectFailureState(this.failure);
}

class InsertFlatObjectInitState extends InsertFlatObjectState with EquatableMixin {
  final FlatObjectValue currentFlatObjectValue;
  final bool shouldDisplayValidationErrors;
  final bool isInserting;
  final bool isInsertSuccessfull;
  final bool isDeleting;
  final bool isDeletionSuccessfull;
  final String? failure;

  InsertFlatObjectInitState({
    required this.currentFlatObjectValue,
    this.shouldDisplayValidationErrors = false,
    this.isDeleting = false,
    this.isDeletionSuccessfull = false,
    this.isInserting = false,
    this.isInsertSuccessfull = false,
    this.failure,
  });

  @override
  List<Object?> get props {
    return [
      currentFlatObjectValue,
      shouldDisplayValidationErrors,
      isInserting,
      isInsertSuccessfull,
      isDeleting,
      isDeletionSuccessfull,
      failure,
    ];
  }

  InsertFlatObjectInitState copyWith({
    FlatObjectValue? currentFlatObjectValue,
    bool? shouldDisplayValidationErrors,
    bool? isInserting,
    bool? isInsertSuccessfull,
    bool? isDeleting,
    bool? isDeletionSuccessfull,
    NullableObject<String>? failure,
  }) {
    return InsertFlatObjectInitState(
      currentFlatObjectValue: currentFlatObjectValue ?? this.currentFlatObjectValue,
      shouldDisplayValidationErrors: shouldDisplayValidationErrors ?? this.shouldDisplayValidationErrors,
      isInserting: isInserting ?? this.isInserting,
      isInsertSuccessfull: isInsertSuccessfull ?? this.isInsertSuccessfull,
      isDeleting: isDeleting ?? this.isDeleting,
      isDeletionSuccessfull: isDeletionSuccessfull ?? this.isDeletionSuccessfull,
      failure: failure == null ? this.failure : failure.value,
    );
  }
}
