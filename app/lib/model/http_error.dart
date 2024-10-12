class HttpError {
  final int statusCode;

  final String? message;

  HttpError({
    required this.statusCode,
    required this.message,
  });
}
