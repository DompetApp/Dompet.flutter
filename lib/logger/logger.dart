import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:flutter/widgets.dart';
import 'package:dompet/logger/output.dart';
import 'package:dompet/logger/printer.dart';

final _consoleOutput = ConsoleOutput();
final _fileSafeOutput = SafeFileOutput(
  filePrefix: 'flutter-',
  fileSuffix: '.txt',
);

class SafeOutputs extends MultiOutput {
  SafeOutputs() : super([_consoleOutput, _fileSafeOutput]);
}

class SafeFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    return event.level.index >= level!.index;
  }
}

class SafeLogger extends Logger {
  SafeLogger({super.level, super.filter, super.output, super.printer});

  void info(dynamic message, [Object? error, StackTrace? stackTrace]) {
    i(message, error: error, stackTrace: stackTrace);
  }

  void debug(dynamic message, [Object? error, StackTrace? stackTrace]) {
    d(message, error: error, stackTrace: stackTrace);
  }

  void error(dynamic message, [Object? error, StackTrace? stackTrace]) {
    e(message, error: error, stackTrace: stackTrace);
  }

  void warning(dynamic message, [Object? error, StackTrace? stackTrace]) {
    w(message, error: error, stackTrace: stackTrace);
  }

  SafeChangeNotifier get _changeNotifier => _fileSafeOutput.changeNotifier;
  SafeChangeListener get removeListener => _changeNotifier.removeListener;
  SafeChangeListener get addListener => _changeNotifier.addListener;

  Future<List<String>?> readAsStrings() async {
    try {
      return _fileSafeOutput.readAsStrings();
    } catch (exception, stack) {
      FlutterError.reportError(
        FlutterErrorDetails(
          library: 'Flutter SafeLogger',
          exception: exception,
          stack: stack,
        ),
      );

      return null;
    }
  }

  Future<FormData?> readAsFormDatas() async {
    try {
      return _fileSafeOutput.readAsFormDatas();
    } catch (exception, stack) {
      FlutterError.reportError(
        FlutterErrorDetails(
          library: 'Flutter SafeLogger',
          exception: exception,
          stack: stack,
        ),
      );

      return null;
    }
  }

  Future<FormData?> readAsFormData() async {
    try {
      return _fileSafeOutput.readAsFormData();
    } catch (exception, stack) {
      FlutterError.reportError(
        FlutterErrorDetails(
          library: 'Flutter SafeLogger',
          exception: exception,
          stack: stack,
        ),
      );

      return null;
    }
  }

  Future<String?> readAsString() async {
    try {
      return _fileSafeOutput.readAsString();
    } catch (exception, stack) {
      FlutterError.reportError(
        FlutterErrorDetails(
          library: 'Flutter SafeLogger',
          exception: exception,
          stack: stack,
        ),
      );

      return null;
    }
  }

  Future<void> clearHistory() async {
    try {
      return _fileSafeOutput.clearHistory();
    } catch (exception, stack) {
      FlutterError.reportError(
        FlutterErrorDetails(
          library: 'Flutter SafeLogger',
          exception: exception,
          stack: stack,
        ),
      );

      return;
    }
  }

  Future<void> clearAll() async {
    try {
      return _fileSafeOutput.clearAll();
    } catch (exception, stack) {
      FlutterError.reportError(
        FlutterErrorDetails(
          library: 'Flutter SafeLogger',
          exception: exception,
          stack: stack,
        ),
      );

      return;
    }
  }

  Future<bool> isEmpty() async {
    try {
      return _fileSafeOutput.isEmpty();
    } catch (exception, stack) {
      FlutterError.reportError(
        FlutterErrorDetails(
          library: 'Flutter SafeLogger',
          exception: exception,
          stack: stack,
        ),
      );

      return true;
    }
  }
}

final logger = SafeLogger(
  filter: SafeFilter(),
  output: SafeOutputs(),
  printer: HybridPrinter(
    SafePrettyPrinter(
      stackTraceBeginIndex: 0,
      errorMethodCount: 10,
      methodCount: 5,
      lineLength: 120,
      printTime: true,
    ),
    debug: SimplePrinter(printTime: true, colors: false),
  ),
);
