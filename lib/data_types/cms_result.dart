class CmsResult<T> {
  final T? data;
  final String? errorMessage;

  const CmsResult._({
    required this.data,
    required this.errorMessage,
  });

  factory CmsResult.success(T data) => CmsResult._(
        data: data,
        errorMessage: null,
      );

  factory CmsResult.error(String errorMessage) => CmsResult._(
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

  CmsResult<S> foldSuccess<S>({
    required S Function(T data) onSuccess,
  }) =>
      fold(
        onError: (errorMessage) => CmsResult.error(errorMessage),
        onSuccess: (data) => CmsResult.success(onSuccess(data)),
      );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CmsResult<T> && other.data == data && other.errorMessage == errorMessage;
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