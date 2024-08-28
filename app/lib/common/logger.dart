import 'dart:developer';

void logDebug(
  String message, {
  String name = '',
}) {
  // Level.FINE
  log(
    message,
    level: 500,
    name: name,
    time: DateTime.now(),
  );
}

void logError(
  String message, {
  String name = '',
  Object? error,
  StackTrace? stack,
}) {
  // Level.SEVERE
  log(
    message,
    level: 1000,
    name: name,
    error: error,
    stackTrace: stack,
    time: DateTime.now(),
  );
}
