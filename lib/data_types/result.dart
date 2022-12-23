class Result<T> {
  final T? data;
  final String? errorMessage;

  const Result._({
    required this.data,
    required this.errorMessage,
  });

  factory Result.success(T data) => Result._(
        data: data,
        errorMessage: null,
      );

  factory Result.error(String errorMessage) => Result._(
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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Result<T> && other.data == data && other.errorMessage == errorMessage;
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
