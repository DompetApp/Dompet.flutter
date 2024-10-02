import 'package:get/get.dart';

mixin RxWatcher {
  late final List<Worker> _workers = [];

  Worker rxDebounce(Rx value, WorkerCallback callback, Duration time) {
    final worker = debounce(value, callback, time: time);

    if (!_workers.contains(worker)) {
      _workers.add(worker);
    }

    return worker;
  }

  Worker rxInterval(Rx value, WorkerCallback callback, Duration time) {
    final worker = interval(value, callback, time: time);

    if (!_workers.contains(worker)) {
      _workers.add(worker);
    }

    return worker;
  }

  Worker rxEvers(List<Rx> rx, WorkerCallback callback) {
    final worker = everAll(rx, callback);

    if (!_workers.contains(worker)) {
      _workers.add(worker);
    }

    return worker;
  }

  Worker rxOnce(Rx rx, WorkerCallback callback) {
    final worker = once(rx, callback);

    if (!_workers.contains(worker)) {
      _workers.add(worker);
    }

    return worker;
  }

  Worker rxEver(Rx rx, WorkerCallback callback) {
    final worker = ever(rx, callback);

    if (!_workers.contains(worker)) {
      _workers.add(worker);
    }

    return worker;
  }

  void rxOff() {
    for (final worker in _workers) {
      if (!worker.disposed) {
        worker.dispose();
      }
    }

    _workers.clear();
  }
}
