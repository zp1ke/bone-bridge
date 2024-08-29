abstract class HttpError {
  int get statusCode;

  String? get message;

  bool get isBadRequest {
    return statusCode == 400;
  }
}
