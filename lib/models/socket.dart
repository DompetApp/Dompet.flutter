class SocketMeta {
  final String type;
  final String code;
  final dynamic data;

  SocketMeta({
    required this.type,
    required this.code,
    this.data,
  });

  SocketMeta clone({
    String? type,
    String? code,
    dynamic data,
  }) {
    return SocketMeta(
      type: type ?? this.type,
      code: code ?? this.code,
      data: data ?? this.data,
    );
  }

  factory SocketMeta.clone({
    required type,
    required String code,
    dynamic data,
  }) {
    return SocketMeta(
      type: type,
      code: code,
      data: data,
    );
  }
}
