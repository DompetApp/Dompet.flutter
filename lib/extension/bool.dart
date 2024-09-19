extension BoolExtension on Object? {
  bool get bv {
    if (this == null) {
      return false;
    }

    if (this is bool) {
      return this as bool;
    }

    if (this is String) {
      final string = this as String;
      return string.isNotEmpty;
    }

    if (this is List) {
      final list = this as List;
      return list.isNotEmpty;
    }

    if (this is Map) {
      final map = this as Map;
      return map.isNotEmpty;
    }

    if (this is num) {
      final number = this as num;
      return number != 0;
    }

    return true;
  }
}
