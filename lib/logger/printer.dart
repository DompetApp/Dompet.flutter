import 'dart:math';
import 'dart:convert';
import 'package:logger/logger.dart';

const onlyTime = SafeDateTimeFormat.onlyTime;
const onlyDate = SafeDateTimeFormat.onlyDate;
const dateAndTime = SafeDateTimeFormat.dateAndTime;
const onlyTimeAndSinceStart = SafeDateTimeFormat.onlyTimeAndSinceStart;
const onlyDateAndSinceStart = SafeDateTimeFormat.onlyDateAndSinceStart;
const dateTimeAndSinceStart = SafeDateTimeFormat.dateTimeAndSinceStart;

typedef DateTimeFormatter = String Function([DateTime? time]);

class SafePrettyPrinter extends LogPrinter {
  static const middleCorner = '├';
  static const singleDivider = '┄';
  static const doubleDivider = '─';
  static const topLeftCorner = '┌';
  static const verticalCorner = '│';
  static const bottomLeftCorner = '└';

  static final DateTime startTime = DateTime.now();

  static final _browserStackTraceRegex = RegExp(
    r'^(?:package:)?(dart:\S+|\S+)',
  );

  static final _deviceStackTraceRegex = RegExp(
    r'#[0-9]+\s+(.+) \((\S+)\)',
  );

  static final _webStackTraceRegex = RegExp(
    r'^((packages|dart-sdk)/\S+/)',
  );

  static final _logStackTraceRegex = RegExp(
    r'^(#[0-9]+\s+(SafePrettyPrinter\.log|SafeLogger\.info)\s+\(package:\S+\))',
  );

  late final Map<Level, bool> includeBox;

  final Map<Level, bool> excludeBox;

  final List<String> excludePaths;

  final int stackTraceBeginIndex;

  final bool noBoxingByDefault;

  final int errorMethodCount;

  final int methodCount;

  final int lineLength;

  final bool printTime;

  String _bottomBorder = '';
  String _middleBorder = '';
  String _topBorder = '';

  SafePrettyPrinter({
    this.lineLength = 80,
    this.methodCount = 5,
    this.errorMethodCount = 10,
    this.stackTraceBeginIndex = 0,
    this.noBoxingByDefault = false,
    this.excludePaths = const [],
    this.excludeBox = const {},
    this.printTime = false,
  }) {
    includeBox = {};

    for (var key in Level.values) {
      includeBox[key] = !noBoxingByDefault;
    }

    for (var obj in excludeBox.entries) {
      includeBox[obj.key] = !obj.value;
    }

    var doubleDividerLine = StringBuffer();
    var singleDividerLine = StringBuffer();

    for (var i = 0; i < lineLength - 1; i++) {
      doubleDividerLine.write(doubleDivider);
      singleDividerLine.write(singleDivider);
    }

    if (startTime.microsecondsSinceEpoch > 0) {}

    _topBorder = '$topLeftCorner$doubleDividerLine';
    _middleBorder = '$middleCorner$singleDividerLine';
    _bottomBorder = '$bottomLeftCorner$doubleDividerLine';
  }

  @override
  List<String> log(LogEvent event) {
    String? timeStr;
    String? stackTraceStr;

    final level = event.level;
    final isError = level == Level.error;
    final errorStr = formatError(event.error);
    final messageStr = formatMessage(event.message);

    if (event.stackTrace != null) {
      final count = max(isError ? errorMethodCount : methodCount, 1);
      stackTraceStr = formatStackTrace(event.stackTrace, count);
    }

    if (event.stackTrace == null) {
      final count = max(isError ? errorMethodCount : methodCount, 1);
      stackTraceStr = formatStackTrace(StackTrace.current, count);
    }

    if (printTime == true) {
      timeStr = SafeDateTimeFormat.dateTimeAndSinceStart(event.time);
    }

    return formater(
      stacktrace: stackTraceStr,
      message: messageStr,
      error: errorStr,
      level: level,
      time: timeStr,
    );
  }

  bool _discardStacktraceLine(String line) {
    if (_discardWebStacktraceLine(line)) {
      return true;
    }

    if (_discardLogStacktraceLine(line)) {
      return true;
    }

    if (_discardDeviceStacktraceLine(line)) {
      return true;
    }

    if (_discardBrowserStacktraceLine(line)) {
      return true;
    }

    return line.isEmpty;
  }

  bool _discardWebStacktraceLine(String line) {
    var match = _webStackTraceRegex.matchAsPrefix(line);

    if (match == null) {
      return false;
    }

    final segment = match.group(1)!;

    if (segment.startsWith('packages/logger')) {
      return true;
    }

    if (segment.startsWith('dart-sdk/lib')) {
      return true;
    }

    for (var element in excludePaths) {
      if (segment.startsWith(element)) {
        return true;
      }
    }

    return false;
  }

  bool _discardLogStacktraceLine(String line) {
    var match = _logStackTraceRegex.matchAsPrefix(line);

    if (match == null) {
      return false;
    }

    final segment = match.group(2)!;

    if (segment.startsWith('SafePrettyPrinter.log')) {
      return true;
    }

    if (segment.startsWith('SafeLogger.info')) {
      return true;
    }

    for (var element in excludePaths) {
      if (segment.startsWith(element)) {
        return true;
      }
    }

    return false;
  }

  bool _discardDeviceStacktraceLine(String line) {
    var match = _deviceStackTraceRegex.matchAsPrefix(line);

    if (match == null) {
      return false;
    }

    final segment = match.group(2)!;

    if (segment.startsWith('package:logger')) {
      return true;
    }

    for (var element in excludePaths) {
      if (segment.startsWith(element)) {
        return true;
      }
    }

    return false;
  }

  bool _discardBrowserStacktraceLine(String line) {
    var match = _browserStackTraceRegex.matchAsPrefix(line);

    if (match == null) {
      return false;
    }

    final segment = match.group(1)!;

    if (segment.startsWith('package:logger')) {
      return true;
    }

    if (segment.startsWith('dart:')) {
      return true;
    }

    for (var element in excludePaths) {
      if (segment.startsWith(element)) {
        return true;
      }
    }

    return false;
  }

  String? formatStackTrace(StackTrace? stackTrace, int methodCount) {
    final lines = stackTrace.toString().split('\n');
    final traces = [...lines.where((line) => !_discardStacktraceLine(line))];
    final List<String> formatted = [];

    for (int count = 0; count < min(traces.length, methodCount); count++) {
      var line = traces[count];

      if (count < stackTraceBeginIndex) {
        continue;
      }

      formatted.add('#$count   ${line.replaceFirst(RegExp(r'#\d+\s+'), '')}');
    }

    if (formatted.isNotEmpty) {
      return formatted.join('\n');
    }

    return null;
  }

  String? formatMessage(dynamic message) {
    final finalMessage = message is Function ? message() : message;

    if (finalMessage is Map || finalMessage is Iterable) {
      var encoder = JsonEncoder.withIndent('  ', (obj) => obj.toString());
      return encoder.convert(finalMessage);
    }

    if (finalMessage != null) {
      return finalMessage.toString();
    }

    return null;
  }

  String? formatError(dynamic error) {
    if (error == null) {
      return null;
    }

    if (error is String) {
      return error;
    }

    return error.toString();
  }

  List<String> formater({
    required Level level,
    required String? message,
    String? time,
    String? error,
    String? stacktrace,
  }) {
    final verticalLine = includeBox[level] == true ? '$verticalCorner ' : '';
    final included = includeBox[level] == true;
    final List<String> buffer = [];
    var border = false;

    final levels = {
      Level.fatal: 'Fatal',
      Level.error: 'Error',
      Level.warning: 'Warning',
      Level.debug: 'Debug',
      Level.info: 'Info',
    };

    if (included) {
      buffer.add(_topBorder);
    }

    if (time != null) {
      buffer.add('$verticalLine${levels[level]} | $time');
      border = true;
    }

    if (message?.isNotEmpty == true) {
      if (border && included) buffer.add(_middleBorder);

      for (var line in message!.split('\n')) {
        buffer.add('$verticalLine$line');
      }

      border = true;
    }

    if (error != null && error.isNotEmpty) {
      if (border && included) buffer.add(_middleBorder);

      for (var line in error.split('\n')) {
        buffer.add('$verticalLine$line');
      }

      border = true;
    }

    if (stacktrace != null && stacktrace.isNotEmpty) {
      if (border && included) buffer.add(_middleBorder);

      for (var line in stacktrace.split('\n')) {
        buffer.add('$verticalLine$line');
      }

      border = true;
    }

    if (included) {
      buffer.add(_bottomBorder);
    }

    return buffer..add('');
  }
}

class SafeDateTimeFormat {
  static const DateTimeFormatter onlyTime = _onlyTime;

  static const DateTimeFormatter onlyDate = _onlyDate;

  static const DateTimeFormatter dateAndTime = _dateAndTime;

  static const DateTimeFormatter onlyTimeAndSinceStart = _onlyTimeAndSinceStart;

  static const DateTimeFormatter onlyDateAndSinceStart = _onlyDateAndSinceStart;

  static const DateTimeFormatter dateTimeAndSinceStart = _dateTimeAndSinceStart;

  static String _dateTimeAndSinceStart([DateTime? t]) {
    final now = t ?? DateTime.now();
    final timeSinceStart = now.difference(SafePrettyPrinter.startTime);
    return '${_onlyDate(now)} ${_onlyTime(now)} (+$timeSinceStart)';
  }

  static String _onlyDateAndSinceStart([DateTime? t]) {
    final now = t ?? DateTime.now();
    final timeSinceStart = now.difference(SafePrettyPrinter.startTime);
    return '${_onlyDate(now)} (+$timeSinceStart)';
  }

  static String _onlyTimeAndSinceStart([DateTime? t]) {
    final now = t ?? DateTime.now();
    final timeSinceStart = now.difference(SafePrettyPrinter.startTime);
    return '${_onlyTime(now)} (+$timeSinceStart)';
  }

  static String _dateAndTime([DateTime? t]) {
    final now = t ?? DateTime.now();
    return "${_onlyDate(now)} ${_onlyTime(now)}";
  }

  static String _onlyDate([DateTime? t]) {
    final now = t ?? DateTime.now();
    final isoDate = now.toIso8601String();
    return isoDate.substring(0, isoDate.indexOf("T"));
  }

  static String _onlyTime([DateTime? t]) {
    String threeDigits(int n) {
      if (n >= 100) return '$n';
      if (n >= 10) return '0$n';
      return '00$n';
    }

    String twoDigits(int n) {
      if (n >= 10) return '$n';
      return '0$n';
    }

    final now = t ?? DateTime.now();
    final hour = twoDigits(now.hour);
    final min = twoDigits(now.minute);
    final sec = twoDigits(now.second);
    final ms = threeDigits(now.millisecond);
    return '$hour:$min:$sec.$ms';
  }
}
