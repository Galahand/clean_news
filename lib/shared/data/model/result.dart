class Result<T> {
  const Result.success(this._data)
      : _error = null,
        loading = false;
  const Result.error(this._error)
      : _data = null,
        loading = false;
  const Result.loading()
      : _data = null,
        _error = null,
        loading = true;

  final T? _data;
  final dynamic _error;
  final bool loading;

  U when<U>(
    U Function(T data) onSuccess,
    U Function(dynamic error) onError,
    U Function() onLoading,
  ) {
    if (loading) return onLoading();
    if (_error != null) {
      return onError(_error);
    }

    final data = _data;
    if (data is T) {
      return onSuccess(data);
    }

    return onError(Exception('Data is not expected type'));
  }
}
