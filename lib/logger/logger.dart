import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:dompet/logger/output.dart';
import 'package:dompet/logger/printer.dart';

final _consoleOutput = ConsoleOutput();
final _fileSafeOutput = SafeFileOutput();

class SafeMultiOutput extends MultiOutput {
  SafeMultiOutput() : super([_consoleOutput, _fileSafeOutput]);
}

class SafeFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    return event.level.index >= level!.index;
  }
}

class SafeLogger extends Logger {
  SafeLogger({super.level, super.filter, super.printer, super.output});

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

  Future<List<String>?> readAsStrings() async {
    return _fileSafeOutput.readAsStrings();
  }

  Future<FormData?> readAsFormDatas() async {
    return _fileSafeOutput.readAsFormDatas();
  }

  Future<FormData?> readAsFormData() async {
    return _fileSafeOutput.readAsFormData();
  }

  Future<String?> readAsString() async {
    return _fileSafeOutput.readAsString();
  }

  Future<void> clearHistory() async {
    return _fileSafeOutput.clearHistory();
  }

  Future<void> clearAll() async {
    return _fileSafeOutput.clearAll();
  }

  Future<bool> isEmpty() async {
    return _fileSafeOutput.isEmpty();
  }
}

final logger = SafeLogger(
  filter: SafeFilter(),
  output: SafeMultiOutput(),
  printer: HybridPrinter(
    SafePrettyPrinter(
      stackTraceBeginIndex: 0,
      errorMethodCount: 10,
      methodCount: 5,
      lineLength: 120,
      printTime: true,
    ),
    debug: SimplePrinter(
      printTime: true,
      colors: false,
    ),
  ),
);
