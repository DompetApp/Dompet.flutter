import 'dart:io';
import 'dart:math';
import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:logger/logger.dart';
import 'package:synchronized/synchronized.dart';
import 'package:path_provider/path_provider.dart' as path;

class SafeFileOutput extends LogOutput {
  final Duration duration = const Duration(minutes: 3);
  final String storage = 'app.dompet.flutter/logger';
  final Lock lock = Lock(reentrant: true);
  final Encoding encoding;
  final bool isOverride;
  final int keepCount;

  Timer? _timer;
  IOSink? _sink;
  String? _name;

  SafeFileOutput({
    this.encoding = utf8,
    this.isOverride = false,
    this.keepCount = 3,
  });

  @override
  Future<void> init() async {
    clearHistory();
  }

  @override
  Future<void> destroy() async {
    await clearIOSink();
  }

  @override
  void output(OutputEvent event) async {
    try {
      final isInfo = Level.info == event.level;
      final isError = Level.error == event.level;
      final isWarning = Level.warning == event.level;

      if (isInfo != true && isError != true && isWarning != true) {
        return;
      }

      if (_sink == null || await createIOName() != _name) {
        await clearIOSink();
        await createIOSink();
      }

      if (_sink == null || _name == null) {
        await clearIOSink();
        return;
      }

      _sink!.writeAll(event.lines, '\n');
    } catch (e) {
      await clearIOSink();
    }
  }

  Future<List<String>?> readAsStrings() async {
    return lock.synchronized(() async {
      if (await isEmpty()) {
        return null;
      }

      if (_sink != null) {
        await _sink!.flush();
      }

      final List<String> logs = [];
      final List<File> files = await getSortedFiles();

      for (final file in files) {
        logs.add(await file.readAsString());
      }

      return logs;
    });
  }

  Future<List<File>> getSortedFiles() async {
    return lock.synchronized(() async {
      if (await isEmpty()) {
        return [];
      }

      if (_sink != null) {
        await _sink!.flush();
      }

      final dir = await getDirectory();
      final list = dir.list().where((f) => f is File);
      final files = await list.cast<File>().toList();

      return files
        ..sort((aFile, bFile) {
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
    });
  }

  Future<FormData?> readAsFormData() async {
    return lock.synchronized(() async {
      if (await isEmpty()) {
        return null;
      }

      final bytes = [];
      final files = await getSortedFiles();

      for (final file in files) {
        bytes.add(
          MultipartFile.fromFileSync(
            file.path,
            filename: basename(file.path),
          ),
        );
      }

      return FormData.fromMap({
        "files": bytes,
      });
    });
  }

  Future<Directory> getDirectory() async {
    final root = await path.getApplicationSupportDirectory();
    return Directory(join(root.path, storage));
  }

  Future<String> createIOName() async {
    return DateFormat('yyyyMMdd').format(DateTime.now());
  }

  Future<void> clearDirectory() async {
    return lock.synchronized(() async {
      final dir = await getDirectory();

      if (dir.existsSync()) {
        dir.deleteSync(recursive: true);
      }
    });
  }

  Future<void> createIOSink() async {
    _timer?.cancel();

    _timer = Timer(duration, clearIOSink);

    return lock.synchronized(() async {
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
    });
  }

  Future<void> clearHistory() async {
    return lock.synchronized(() async {
      final files = await getSortedFiles();
      final limit = files.length > max(keepCount, 1);
      final array = limit ? files.sublist(keepCount) : null;

      if (array == null) {
        return;
      }

      for (final file in array) {
        try {
          if (await file.exists()) {
            await file.delete();
          }
        } catch (e) {/* e */}
      }
    });
  }

  Future<void> clearIOSink() async {
    return lock.synchronized(() async {
      if (_sink != null) {
        await _sink!.flush();
        await _sink!.close();
      }

      _timer?.cancel();
      _timer = null;
      _name = null;
      _sink = null;
    });
  }

  Future<void> clearAll() async {
    return lock.synchronized(() async {
      await clearIOSink();
      await clearDirectory();
    });
  }

  Future<bool> isEmpty() async {
    try {
      await clearHistory();
    } catch (e) {/* e */}

    return lock.synchronized(() async {
      try {
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
    });
  }
}
