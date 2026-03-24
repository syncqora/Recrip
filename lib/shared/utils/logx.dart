import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For formatting the date and time

/// Enum to define various log levels.
enum LogLevel { debug, info, warning, error }

/// ANSI color codes for colorful console output.
class AnsiColors {
  static const String reset = '\x1B[0m'; // Reset to default
  static const String red = '\x1B[31m'; // Red text
  static const String green = '\x1B[32m'; // Green text
  static const String yellow = '\x1B[33m'; // Yellow text
  static const String blue = '\x1B[34m'; // Blue text
  static const String magenta = '\x1B[35m'; // Magenta text
  static const String cyan = '\x1B[36m'; // Cyan text
  static const String white = '\x1B[37m'; // White text
}

/// A logger class to handle logging with color, formatting, and different log levels.
class LogX {
  String appTitle;
  bool is24HourFormat;
  bool useBoxyFormat;
  bool includeTimestamps;
  LogLevel currentLogLevel;
  final StringBuffer _logBuffer = StringBuffer();

  /// Constructor for `LogX` allowing configuration of log settings.
  LogX({
    this.appTitle = 'APPTITLE',
    this.is24HourFormat = true,
    this.useBoxyFormat = true,
    this.includeTimestamps = false, // Set to false to remove the timestamp line
    this.currentLogLevel = LogLevel.debug,
  });

  /// Logs an info message in green.
  void info(String message, [dynamic error, StackTrace? stackTrace]) {
    _log('INFO', message, AnsiColors.green, LogLevel.info, error, stackTrace);
  }

  /// Logs a warning message in yellow.
  void warning(String message, [dynamic error, StackTrace? stackTrace]) {
    _log(
      'WARNING',
      message,
      AnsiColors.yellow,
      LogLevel.warning,
      error,
      stackTrace,
    );
  }

  /// Logs an error message in red. Handles and formats stack trace if provided.
  void error(String message, [dynamic error, StackTrace? stackTrace]) {
    // Handle large error logs
    _handleLargeLogs(
      message,
      (msg) =>
          _log('ERROR', msg, AnsiColors.red, LogLevel.error, error, stackTrace),
    );
  }

  /// Logs a debug message in blue.
  void debug(String message, [dynamic error, StackTrace? stackTrace]) {
    _log('DEBUG', message, AnsiColors.blue, LogLevel.debug, error, stackTrace);
  }

  /// Logs a JSON string in a pretty format.
  void prettyJson(String jsonString) {
    try {
      final dynamic jsonObject = json.decode(jsonString);
      final prettyString = const JsonEncoder.withIndent(
        '  ',
      ).convert(jsonObject);
      _handleLargeLogs(
        jsonString,
        (msg) => _log('JSON', prettyString, AnsiColors.cyan, LogLevel.info),
      );
    } catch (e) {
      error('Invalid JSON string provided for pretty logging.');
    }
  }

  /// Retrieves the appropriate emoji for the given log level.
  String _getEmojiForLevel(LogLevel level) {
    switch (level) {
      case LogLevel.info:
        return '💡'; // Info emoji
      case LogLevel.warning:
        return '⚠️'; // Warning emoji
      case LogLevel.error:
        return '❌'; // Error emoji
      case LogLevel.debug:
        return '🐞'; // Debug emoji
    }
  }

  /// General method to log messages with a specific color and level.
  ///
  /// [level] - Log level (e.g., INFO, WARNING).
  /// [message] - The message to log.
  /// [color] - ANSI color code for the message.
  /// [logLevel] - Log level as `LogLevel` enum.
  /// [error] - Optional error object.
  /// [stackTrace] - Optional stack trace.
  void _log(
    String level,
    String message,
    String color,
    LogLevel logLevel, [
    dynamic error,
    StackTrace? stackTrace,
  ]) {
    if (logLevel.index >= currentLogLevel.index) {
      final String timestamp = includeTimestamps ? _getTimestamp() : '';
      final String emoji = _getEmojiForLevel(logLevel);

      // Format stack trace if provided
      String formattedStackTrace = '';
      if (stackTrace != null) {
        formattedStackTrace = _formatStackTrace(stackTrace);
      }

      final String formattedMessage = message;

      // Boxy formatting
      if (useBoxyFormat) {
        _printBoxyLog(
          formattedMessage,
          formattedStackTrace,
          '$emoji $timestamp -  [${logLevel.name.toUpperCase()}]',
          color,
        );
      } else {
        _printFormatted('$color$formattedMessage${AnsiColors.reset}');
      }

      _logToBuffer(level, message, error, stackTrace);
    }
  }

  /// Handles large log messages by splitting them into manageable chunks.
  ///
  /// [message] - The message to log.
  /// [logFunction] - The function to log each chunk.
  void _handleLargeLogs(String message, Function(String) logFunction) {
    const int chunkSize = 800; // Define your chunk size
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

  /// Prints a formatted boxy log message with color and alignment.
  ///
  /// [message] - The log message to print.
  /// [stackTrace] - The formatted stack trace.
  /// [timestamp] - The timestamp to print.
  /// [color] - The ANSI color code for the box.
  void _printBoxyLog(
    String message,
    String stackTrace,
    String timestamp,
    String color,
  ) {
    final String header = '$color┌${'─' * 100}┐${AnsiColors.reset}';
    final String footer = '$color└${'─' * 100}┘${AnsiColors.reset}';
    final String separator = '$color├${'─' * 100}┤${AnsiColors.reset}';

    _printFormatted(header);

    // Print timestamp only if it's enabled
    if (includeTimestamps && timestamp.isNotEmpty) {
      _printFormatted('$color│ $timestamp${AnsiColors.reset}');
      _printFormatted(separator);
    }
    // Print message only if it's not empty
    if (message.isNotEmpty) {
      for (var line in message.split('\n')) {
        _printFormatted('$color│ $line${AnsiColors.reset}');
      }
    }
    // Print stack trace if available
    if (stackTrace.isNotEmpty) {
      for (var line in stackTrace.split('\n')) {
        _printFormatted('$color│ $line${AnsiColors.reset}');
      }
      _printFormatted(separator);
    }

    _printFormatted(footer);
  }

  // /// Aligns each line within the box.
  // ///
  // /// [line] - The line to align.
  // /// [width] - The width of the box.
  // String _alignLine(String line, int width) {
  //   line = line.trim(); // Remove any unwanted leading or trailing whitespace
  //   final int paddingLength =
  //       width - line.length - 2; // Adjusting width for padding and borders
  //   final String padding = ' ' * (paddingLength > 0 ? paddingLength : 0);
  //   return line + padding + ' │';
  // }

  /// Prints the formatted log message using debugPrint to avoid the `I/flutter` prefix.
  ///
  /// [message] - The message to print.
  void _printFormatted(String message) {
    debugPrint('\x1B[0m$message\x1B[0m'); // Reset colors to avoid bleed
  }

  /// Formats the stack trace to a readable string format.
  ///
  /// [stackTrace] - The stack trace to format.
  /// Returns a formatted string representation of the stack trace.
  String _formatStackTrace(StackTrace? stackTrace) {
    if (stackTrace == null) return '';
    final frames = stackTrace
        .toString()
        .split('\n')
        .take(5); // Take the top 5 frames for compactness
    return frames
        .map((frame) => frame.trim())
        .join('\n'); // Aligning stack trace within the box
  }

  /// Logs a message with the specified level to the buffer.
  ///
  /// [level] - The level of the log (e.g., DEBUG, INFO).
  /// [message] - The message to log.
  /// [error] - Optional error object.
  /// [stackTrace] - Optional stack trace.
  void _logToBuffer(
    String level,
    String message, [
    dynamic error,
    StackTrace? stackTrace,
  ]) {
    _handleLargeLogs(
      message,
      (msg) => _logBuffer.writeln('${DateTime.now()}: $level - $msg'),
    );
    if (error != null) {
      _logBuffer.writeln('Error: $error');
    }
    if (stackTrace != null) {
      _logBuffer.writeln('StackTrace: ${_formatStackTrace(stackTrace)}');
    }
  }

  /// Retrieves all logged messages from the buffer.
  ///
  /// Returns all log messages as a single string.
  void printAllLogs() {
    // Return complete logs even if they are large
    final logs = _logBuffer.toString();
    // Print the logs in chunks if too large
    _handleLargeLogs(logs, (chunk) {
      debugPrint(chunk);
    });
  }

  /// Clears all logged messages from the buffer. Useful for clearing logs on app close.
  void clearLogs() {
    _logBuffer.clear();
  }

  /// Get the current timestamp in the specified format.
  ///
  /// Returns the formatted timestamp string.
  String _getTimestamp() {
    final DateTime now = DateTime.now();
    final String format = is24HourFormat ? 'HH:mm:ss' : 'hh:mm:ss a';
    return DateFormat(format).format(now);
  }
}
