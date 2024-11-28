import 'dart:io';
import 'dart:math';
import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:logger/logger.dart';
import 'package:flutter/material.dart';
import 'package:synchronized/synchronized.dart';
import 'package:path_provider/path_provider.dart' as path;

typedef SafeChangeListener = void Function(void Function() listener);

class SafeChangeNotifier extends ChangeNotifier {
  @override
  void notifyListeners() {
    super.notifyListeners();
  }
}

class SafeFileOutput extends LogOutput {
  final SafeChangeNotifier changeNotifier = SafeChangeNotifier();
  final String storage = 'app.dompet.flutter/logger/output';
  final Duration time = const Duration(minutes: 3);
  final Lock lock = Lock(reentrant: true);
  final DateFormat dateFormat;
  final Encoding encoding;
  final bool isOverride;
  final int count;

  Timer? _timer;
  IOSink? _sink;
  String? _name;

  SafeFileOutput({
    this.count = 3,
    this.encoding = utf8,
    this.isOverride = false,
    DateFormat? fileFormatter,
  }) : dateFormat = fileFormatter ?? DateFormat('yyyyMMdd');

  @override
  Future<void> init() async {
    clearHistory();
  }

  @override
  Future<void> destroy() async {
    return lock.synchronized(() => clearIOSink());
  }

  @override
  void output(OutputEvent event) async {
    try {
      _timer?.cancel();

      _timer = Timer(time, clearIOSink);

      final isInfo = Level.info == event.level;
      final isError = Level.error == event.level;
      final isWarning = Level.warning == event.level;

      if (isInfo != true && isError != true && isWarning != true) {
        return;
      }

      await lock.synchronized(() async {
        if (_sink == null || await createIOName() != _name) {
          await clearIOSink();
          await createIOSink();
        }

        if (_sink == null || _name == null) {
          await clearIOSink();
          return;
        }

        _sink!.writeAll(event.lines, '\n');
      });

      changeNotifier.notifyListeners();
    } catch (e) {
      await clearIOSink();
    }
  }

  Future<List<File>?> getSortedFiles() async {
    if (await isEmpty()) {
      return null;
    }

    final dir = await getDirectory();
    final list = dir.list().where((f) => f is File);
    final files = await list.cast<File>().toList();

    if (files.isNotEmpty) {
      files.sort((aFile, bFile) {
        List<String> aPaths = aFile.path.split('/');
        List<String> bPaths = bFile.path.split('/');

        final aName = aPaths.last.replaceAll('.log', '');
        final bName = bPaths.last.replaceAll('.log', '');
        final aDate = DateTime.tryParse(aName);
        final bDate = DateTime.tryParse(bName);

        if (aDate == null || bDate == null) {
          return aDate != null ? -1 : 1;
        }

        return bDate.compareTo(aDate);
      });

      return files;
    }

    return null;
  }

  Future<List<String>?> readAsStrings() async {
    return lock.synchronized(() async {
      if (await isEmpty()) {
        return null;
      }

      if (_sink != null) {
        await _sink!.flush();
      }

      final List<File>? files = await getSortedFiles();
      final List<String> logs = [];

      if (files == null || files.isEmpty) {
        return null;
      }

      for (final file in files) {
        logs.add(await file.readAsString(encoding: encoding));
      }

      return logs;
    });
  }

  Future<FormData?> readAsFormDatas() async {
    return lock.synchronized(() async {
      if (await isEmpty()) {
        return null;
      }

      if (_sink != null) {
        await _sink!.flush();
      }

      final formData = FormData();
      final files = await getSortedFiles();

      if (files == null || files.isEmpty) {
        return null;
      }

      for (final file in files) {
        final name = basename(file.path);
        final path = file.path;

        formData.files.add(
          MapEntry('files', MultipartFile.fromFileSync(path, filename: name)),
        );
      }

      return formData;
    });
  }

  Future<FormData?> readAsFormData() async {
    return lock.synchronized(() async {
      if (await isEmpty()) {
        return null;
      }

      if (_sink != null) {
        await _sink!.flush();
      }

      final formData = FormData();
      final files = await getSortedFiles();

      if (files == null || files.isEmpty) {
        return null;
      }

      final name = basename(files.first.path);
      final path = files.first.path;

      formData.files.add(
        MapEntry('file', MultipartFile.fromFileSync(path, filename: name)),
      );

      return formData;
    });
  }

  Future<Directory> getDirectory() async {
    final root = await path.getApplicationSupportDirectory();
    return Directory(join(root.path, storage));
  }

  Future<String?> readAsString() async {
    return lock.synchronized(() async {
      if (await isEmpty()) {
        return null;
      }

      if (_sink != null) {
        await _sink!.flush();
      }

      final files = await getSortedFiles();

      if (files == null || files.isEmpty) {
        return null;
      }

      return files.first.readAsString(encoding: encoding);
    });
  }

  Future<String> createIOName() async {
    return dateFormat.format(DateTime.now());
  }

  Future<void> clearDirectory() async {
    final dir = await getDirectory();

    if (dir.existsSync()) {
      dir.deleteSync(recursive: true);
    }
  }

  Future<void> createIOSink() async {
    final fileDir = await getDirectory();
    final fileName = await createIOName();
    final filePath = join(fileDir.path, '$fileName.log');
    final fileRefer = File(filePath);

    if (!fileDir.existsSync()) fileDir.createSync(recursive: true);

    _sink = fileRefer.openWrite(
      mode: isOverride ? FileMode.writeOnly : FileMode.writeOnlyAppend,
      encoding: encoding,
    );

    _name = fileName;
  }

  Future<void> clearHistory() async {
    try {
      final files = await getSortedFiles();
      final limit = files != null && files.length > max(count, 1);
      final array = limit ? files.sublist(count, files.length) : null;

      if (array == null || array.isEmpty) {
        return;
      }

      for (final file in array) {
        try {
          if (await file.exists()) {
            await file.delete();
          }
        } catch (e) {/* e */}
      }
    } catch (e) {/* e */}
  }

  Future<void> clearIOSink() async {
    if (_sink != null) {
      await _sink!.flush();
      await _sink!.close();
    }

    _timer?.cancel();
    _timer = null;
    _name = null;
    _sink = null;
  }

  Future<void> clearAll() async {
    return lock.synchronized(() async {
      try {
        await clearIOSink();
        await clearDirectory();
      } catch (e) {/* e */}
    });
  }

  Future<bool> isEmpty() async {
    try {
      await clearHistory();

      final dir = await getDirectory();

      if (!dir.existsSync()) return true;

      final files = await dir.list().toList();

      for (final file in files) {
        if (file is File) {
          return false;
        }
      }
    } catch (e) {/* e */}

    return true;
  }
}
