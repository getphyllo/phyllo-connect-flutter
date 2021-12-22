class Result<T> {
  Result._();

  factory Result.success(T value) = Success<T>;

  factory Result.error(T message) = Error<T>;
}

class Success<T> extends Result<T> {
  Success(this.value) : super._();
  final T value;
}

class Error<T> extends Result<T> {
  Error(this.message) : super._();
  final T message;
}
