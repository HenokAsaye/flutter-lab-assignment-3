/// A generic wrapper class for API responses that can contain either data or an error.
///
/// Type parameter [T] represents the type of data that will be contained in a successful response.
class ApiResponse<T> {
  /// The data returned by the API in case of a successful response.
  /// Will be null if [isSuccess] is false.
  final T? _data;

  /// The error message in case of a failed response.
  /// Will be null if [isSuccess] is true.
  final String? error;

  /// Indicates whether the API call was successful.
  final bool isSuccess;

  /// Private constructor to enforce using factory methods.
  const ApiResponse._({
    T? data,
    this.error,
    required this.isSuccess,
  }) : _data = data;

  /// Creates a successful response containing the provided [data].
  factory ApiResponse.success(T data) {
    return ApiResponse._(
      data: data,
      isSuccess: true,
    );
  }

  /// Creates an error response with the provided error [message].
  factory ApiResponse.error(String message) {
    return ApiResponse._(
      error: message,
      isSuccess: false,
    );
  }

  /// Gets the data if it exists, otherwise throws an error.
  T get data {
    if (isSuccess && _data != null) {
      return _data;
    }
    throw StateError('Cannot access data in error response');
  }

  /// Safely gets the data without throwing an error.
  T? get dataOrNull => _data;

  /// Transforms the data in this response using the provided [transform] function.
  ///
  /// If this is a success response, applies [transform] to the data and returns
  /// a new success response with the transformed data.
  /// If this is an error response, returns a new error response with the same error.
  ApiResponse<R> map<R>(R Function(T data) transform) {
    if (isSuccess && _data != null) {
      return ApiResponse.success(transform(_data));
    }
    return ApiResponse.error(error ?? 'Unknown error');
  }

  /// Returns whether this response contains data.
  bool get hasData => _data != null;

  @override
  String toString() {
    if (isSuccess) {
      return 'ApiResponse{success: $_data}';
    } else {
      return 'ApiResponse{error: $error}';
    }
  }
}
