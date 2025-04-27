// ignore_for_file: camel_case_types

typedef M = Map<dynamic, dynamic>;

class doctor {
  static hyphenCase<T extends M>(T json, [bool first = false]) {
    final arrays = Map.from(json).entries;

    for (final arr in arrays) {
      if (arr.key is! String) {
        continue;
      }

      String key = arr.key;
      RegExp regex1 = RegExp(r'([A-Z])');
      RegExp regex2 = RegExp(r'([_-])([a-zA-Z])');

      if (key.isNotEmpty) {
        key = key.replaceAllMapped(regex1, (match) => '-${match.group(1)}');
        key = key.replaceAllMapped(regex2, (match) => '-${match.group(2)}');
      }

      if (first) {
        key = key.replaceAll(RegExp(r'^[_-]+'), '');
      }

      key = key.toLowerCase();

      json[key] = arr.value;
    }

    return json;
  }

  static underCase<T extends M>(T json, [bool first = false]) {
    final arrays = Map.from(json).entries;

    for (final arr in arrays) {
      if (arr.key is! String) {
        continue;
      }

      String key = arr.key;
      RegExp regex1 = RegExp(r'([A-Z])');
      RegExp regex2 = RegExp(r'([_-])([a-zA-Z])');

      if (key.isNotEmpty) {
        key = key.replaceAllMapped(regex1, (match) => '_${match.group(1)}');
        key = key.replaceAllMapped(regex2, (match) => '_${match.group(2)}');
      }

      if (first) {
        key = key.replaceAll(RegExp(r'^[_-]+'), '');
      }

      key = key.toLowerCase();

      json[key] = arr.value;
    }

    return json;
  }

  static camelCase<T extends M>(T json, [bool first = false]) {
    final arrays = Map.from(json).entries;

    for (final arr in arrays) {
      if (arr.key is! String) {
        continue;
      }

      String key = arr.key;
      dynamic value = arr.value;

      key = key.replaceAllMapped(
        first ? RegExp(r'(^|[_-])([a-z])') : RegExp(r'[_-]([a-z])'),
        (match) => match.group(first ? 2 : 1)?.toUpperCase() ?? '',
      );

      json[key] = value;
    }

    return json;
  }

  static upperCase<T extends M>(T json) {
    final arrays = Map.from(json).entries;

    for (final arr in arrays) {
      if (arr.key is! String) {
        continue;
      }

      String key = arr.key;
      dynamic value = arr.value;

      json[key.toUpperCase()] = value;
    }

    return json;
  }

  static lowerCase<T extends M>(T json) {
    final arrays = Map.from(json).entries;

    for (final arr in arrays) {
      if (arr.key is! String) {
        continue;
      }

      String key = arr.key;
      dynamic value = arr.value;

      json[key.toLowerCase()] = value;
    }

    return json;
  }
}
