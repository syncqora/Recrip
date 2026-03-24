import 'package:logger/logger.dart';
import 'package:stack_trace/stack_trace.dart';

/// A singleton logger class that provides various logging levels and
/// maintains a log buffer for retrieving logs.
class AppLogger {
  /// A static instance of `AppLogger` to ensure singleton pattern.
  static final AppLogger _instance = AppLogger._internal();

  /// Factory constructor to return the singleton instance.
  factory AppLogger() {
    return _instance;
  }

  /// Internal constructor to initialize the logger and log buffer.
  AppLogger._internal() {
    _logBuffer = StringBuffer();
    _logger = Logger(
      printer: PrettyPrinter(
        methodCount: 2,
        errorMethodCount: 5,
        lineLength: 120,
        colors: true,
        printEmojis: true,
        dateTimeFormat: DateTimeFormat.dateAndTime,
      ),
    );
  }

  /// Logger instance for logging messages.
  late final Logger _logger;

  /// Buffer to store log messages.
  late final StringBuffer _logBuffer;

  /// Logs a message with the specified level to the buffer.
  ///
  /// [level] The level of the log (e.g., DEBUG, INFO).
  /// [message] The message to log.
  /// [error] Optional error object.
  /// [stackTrace] Optional stack trace.
  void _logToBuffer(
    String level,
    String message, [
    dynamic error,
    StackTrace? stackTrace,
  ]) {
    _logBuffer.writeln('${DateTime.now()}: $level - $message');
    if (error != null) {
      _logBuffer.writeln('Error: $error');
    }
    if (stackTrace != null) {
      _logBuffer.writeln('StackTrace: $stackTrace');
    }
  }

  /// Logs a debug message.
  ///
  /// [message] The message to log.
  /// [error] Optional error object.
  /// [stackTrace] Optional stack trace.
  void debug(String message, [dynamic error, StackTrace? stackTrace]) {
    _logToBuffer('DEBUG', message, error, stackTrace);
    _logger.e(message, error: error, stackTrace: stackTrace);
  }

  /// Logs an info message.
  ///
  /// [message] The message to log.
  /// [error] Optional error object.
  /// [stackTrace] Optional stack trace.
  void info(String message, [dynamic error, StackTrace? stackTrace]) {
    _logToBuffer('INFO', message, error, stackTrace);
    final formattedStackTrace = _formatStackTrace(stackTrace);
    _handleLargeLogs(
      message,
      (msg) => _logger.i(
        message,
        error: error,
        stackTrace: StackTrace.fromString(formattedStackTrace),
      ),
    );
  }

  /// Logs a warning message.
  ///
  /// [message] The message to log.
  /// [error] Optional error object.
  /// [stackTrace] Optional stack trace.
  void warning(String message, [dynamic error, StackTrace? stackTrace]) {
    _logToBuffer('WARNING', message, error, stackTrace);
    _logger.w(message);
  }

  /// Logs an error message.
  ///
  /// [message] The message to log.
  /// [error] Optional error object.
  /// [stackTrace] Optional stack trace.
  void error(String message, [dynamic error, StackTrace? stackTrace]) {
    _logToBuffer('ERROR', message, error, stackTrace);
    _handleLargeLogs(message, (msg) => _logger.e(msg, error: error));
  }

  /// Logs a verbose message.
  ///
  /// [message] The message to log.
  /// [error] Optional error object.
  /// [stackTrace] Optional stack trace.
  void verbose(String message, [dynamic error, StackTrace? stackTrace]) {
    _logToBuffer('VERBOSE', message, error, stackTrace);
    _logger.e(message, error: error);
  }

  /// Logs a WTF (What a Terrible Failure) message.
  ///
  /// [message] The message to log.
  /// [error] Optional error object.
  /// [stackTrace] Optional stack trace.
  void wtf(String message, [dynamic error, StackTrace? stackTrace]) {
    _logToBuffer('WTF', message, error, stackTrace);
    _logger.e(message, error: error);
  }

  /// Logs a pull message.
  ///
  /// [message] The message to log.
  /// [error] Optional error object.
  /// [stackTrace] Optional stack trace.
  void pull(String message, [dynamic error, StackTrace? stackTrace]) {
    _handleLargeLogs(message, (msg) => _logger.e(msg, error: error));
  }

  /// Handles large log messages by splitting them into chunks and logging each chunk.
  ///
  /// [message] The large message to log.
  /// [logFunction] The function to log each chunk.
  void _handleLargeLogs(String message, Function(String) logFunction) {
    const int chunkSize = 1500; // Define your chunk size
    if (message.length <= chunkSize) {
      logFunction(message);
    } else {
      int start = 0;
      while (start < message.length) {
        final end = (start + chunkSize < message.length)
            ? start + chunkSize
            : message.length;
        logFunction(message.substring(start, end));
        start += chunkSize;
      }
    }
  }

  /// Formats the stack trace to a readable string format.
  ///
  /// [stackTrace] The stack trace to format.
  /// Returns a formatted string representation of the stack trace.
  String _formatStackTrace(StackTrace? stackTrace) {
    if (stackTrace == null) return '';
    final frames = Trace.from(stackTrace).frames;
    return frames
        .map((frame) => '${frame.member} (${frame.location})')
        .take(10) // Take only the top 10 frames for compactness
        .join('\n');
  }

  /// Retrieves all logged messages from the buffer.
  ///
  /// Returns all log messages as a single string.
  String getAllLogs() {
    return _logBuffer.toString();
  }
}
