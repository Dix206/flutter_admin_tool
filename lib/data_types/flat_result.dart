class FlatResult<T> {
  final T? data;
  final String? errorMessage;

  const FlatResult._({
    required this.data,
    required this.errorMessage,
  });

  factory FlatResult.success(T data) => FlatResult._(
        data: data,
        errorMessage: null,
      );

  factory FlatResult.error(String errorMessage) => FlatResult._(
        data: null,
        errorMessage: errorMessage,
      );

  bool get isSuccess => data != null;

  bool get hasFailed => errorMessage != null;

  S fold<S>({
    required S Function(String errorMessage) onError,
    required S Function(T data) onSuccess,
  }) {
    if (data != null) {
      return onSuccess(data as T);
    } else {
      return onError(errorMessage!);
    }
  }

  FlatResult<S> foldSuccess<S>({
    required S Function(T data) onSuccess,
  }) =>
      fold(
        onError: (errorMessage) => FlatResult.error(errorMessage),
        onSuccess: (data) => FlatResult.success(onSuccess(data)),
      );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is FlatResult<T> &&
        other.data == data &&
        other.errorMessage == errorMessage;
  }

  @override
  int get hashCode => data.hashCode ^ errorMessage.hashCode;
}

class Unit {
  const Unit();

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Unit;
  }

  @override
  int get hashCode => 0;
}
