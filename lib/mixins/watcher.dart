import 'package:get/get.dart' show WorkerCallback;
import 'package:get/get.dart' show Worker;
import 'package:get/get.dart' show Rx;
import 'package:get/get.dart' as getx;

mixin RxWatcher {
  late final rw = RxWorker();
}

class RxWorker {
  late final List<Worker> _workers = [];

  Worker debounce(Rx value, WorkerCallback callback, Duration time) {
    final worker = getx.debounce(value, callback, time: time);

    if (!_workers.contains(worker)) {
      _workers.add(worker);
    }

    return worker;
  }

  Worker interval(Rx value, WorkerCallback callback, Duration time) {
    final worker = getx.interval(value, callback, time: time);

    if (!_workers.contains(worker)) {
      _workers.add(worker);
    }

    return worker;
  }

  Worker everAll(List<Rx> values, WorkerCallback callback) {
    final worker = getx.everAll(values, callback);

    if (!_workers.contains(worker)) {
      _workers.add(worker);
    }

    return worker;
  }

  Worker ever(Rx value, WorkerCallback callback) {
    final worker = getx.ever(value, callback);

    if (!_workers.contains(worker)) {
      _workers.add(worker);
    }

    return worker;
  }

  Worker once(Rx value, WorkerCallback callback) {
    final worker = getx.once(value, callback);

    if (!_workers.contains(worker)) {
      _workers.add(worker);
    }

    return worker;
  }

  void close() {
    for (final worker in _workers) {
      if (!worker.disposed) {
        worker.dispose();
      }
    }
    _workers.clear();
  }
}
